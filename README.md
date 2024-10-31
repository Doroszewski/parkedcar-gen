A simple generator of `*_parkedcar.pathset` files for Midtown Madness 2 with
[MM2Hook](https://github.com/Dummiesman/mm2hook).

Usage
=====

The coordinates of each parked car position need to be placed in a simple
comma-separated values (CSV) file.

Each potential position is represented by one line. It contains the coordinates
and the rotation of a car (in degrees).

```csv
-14, 0.25, 25, 90
```

Every line which has more or less than 4 comma-separated parameters is ignored.
The same happens to 4-parameter lines with incorrect data. This can be used
to leave comments in a file.

To generate a .pathset file, just run the binary with the source CSV file as
the first argument.

Some additional options are supported, use `parkedcar-gen --help` for more
information.

Example file
------------

```csv
UM, front, right
-49, 0.25, 28.5, 180
-46, 0.25, 28.5, 0
-43, 0.25, 28.5, 180
-40, 0.25, 28.5, 0
-37, 0.25, 28.5, 0
-34, 0.25, 28.5, 0
-31, 0.25, 28.5, 0
-28, 0.25, 28.5, 0

UM, front, left
-73, 0.25, 28.5, 180
-76, 0.25, 28.5, 0
-79, 0.25, 28.5, 180
-82, 0.25, 28.5, 180
-85, 0.25, 28.5, 0
-88, 0.25, 28.5, 0
```
