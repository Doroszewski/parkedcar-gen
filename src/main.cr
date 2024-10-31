require "option_parser"
require "json"
require "csv"

version = "Parked Car Pathset Generator\n\
           Piotr \"Drogosław\" Doroszewski, 2024"

output_file = ""
debug = false
invert = false

OptionParser.parse do |parser|
  parser.banner = "Usage: #{PROGRAM_NAME} FILE [options]"
  parser.on("-d", "--debug", "Enables debug mode") { debug = true }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }
  parser.on("-i", "--invert", "Invert x axis to have normal coordinate space") { invert = true }
  parser.on("-o", "--output=FILE", "Output to FILE") { |x| output_file = x }
  parser.on("--version", "Show version info") { puts version; exit }
  parser.invalid_option do |flag|
    puts "ERROR: #{flag} is not a valid option."
    puts parser
    exit 1
  end
end

points = Array({Float32, Float32, Float32, Float32}).new
fpoints = Array({Float32, Float32, Float32}).new

i = ARGF
if output_file == ""
  if ARGV.size == 0
    o = STDOUT
  else
    o = File.open(ARGV[0].sub(/\.csv$/, ".pathset"), "w")
  end
else
  o = File.open(output_file, "w")
end

CSV.parse(i).each do | l |
  next if l.size != 4
  begin
    points.push({l[0].to_f32, l[1].to_f32, l[2].to_f32, l[3].to_f32})
  rescue
    next
  end
end


points.each do | p |
  f = facing(p[0], p[1], p[2], p[3])
  fpoints.push({f[0], f[1], f[2]})
end


o.write("PTH1".to_slice)
o.write_bytes(1_u32)
o.write_bytes(1_u32)

o.write(("giz_pcar01_l" + ("\0" * 20)).to_slice)
o.write_bytes((points.size * 2).to_u32)
o.write("STRT".to_slice)

fpn = 0
points.each do | p |
  o.write("PNT ".to_slice)
  o.write_bytes(invert ? -p[0] : p[0])
  o.write_bytes(p[1])
  o.write_bytes(p[2])

  o.write("ROT ".to_slice)
  fp = fpoints[fpn]
  o.write_bytes(invert ? -fp[0] : fp[0])
  o.write_bytes(fp[1])
  o.write_bytes(fp[2])
  fpn += 1
end

o.write_bytes(1_u8) # type
o.write_bytes(1_u8) # spacing
o.write("PD".to_slice)

pp points if debug

o.close


def facing(x, y, z, degrees) : {Float32, Float32, Float32}
  # Thanks to Dummiesman for providing me with this algorithm!
  # #mm2-chat @ Midtown Club @ 2025-10-31
  degrees += 90
  radians =  degrees * 0.0174533
  f = {
    Math.cos(radians) + x,
    y,
    Math.sin(radians) + z
  }
  return f
end
