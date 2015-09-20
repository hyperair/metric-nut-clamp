include <MCAD/units/metric.scad>
use <MCAD/shapes/2Dshapes.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>
use <MCAD/shapes/polyhole.scad>

width = 15;
jaw_depth = width - 5;
jaw_length = 12;
thickness = 11;
jaw_thickness = 5;
length = 25;
screw_size = 4;
clearance = 0.3;
round_r = 1;
nut_depth = 1.5;

jaw_offset = length - jaw_thickness;
screw_jaw_thickness = length - jaw_length - jaw_thickness;

module stretch (translation)
{
    hull () {
        children ();

        translate (translation)
        children ();
    }
}

module round (r)
offset (r)
offset (-r)
children ();

difference () {
    linear_extrude (thickness)
    difference () {
        round (r = round_r)
        square ([length, width]);

        translate ([jaw_thickness, width - jaw_depth])
        square ([jaw_length, jaw_depth + epsilon]);
    }

    translate ([
            jaw_thickness + jaw_length,
            (width - jaw_depth) + jaw_depth / 2,
            thickness / 2
        ])
    rotate (-90, Y) {
        stretch ([0, 100, 0])
        rotate (90, Z)
        translate ([0, 0, -nut_depth])
        mirror (Z)
        mcad_nut_hole (size = screw_size, tolerance = 0.01);

        translate ([0, 0, epsilon])
        mirror (Z)
        mcad_polyhole (d = screw_size + clearance,
            h = screw_jaw_thickness + 2);
    }
}
