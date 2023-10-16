include <config\config.scad>;
use <modules\bottom.module.scad>;
use <modules\side_rim.module.scad>;

$fn = 50;

led_r = 1.5;
margin_y = 8;
margin_x = 5;
base_skip_x = 10;
base_skip_y = 7;
thickness = 2;
eps = 0.05;
screw_holes = true;

pattern = [
    [1, 1, 1 ],
    [1, 0, 0 ],
    [1, 1, 0 ],
    [1, 0, 0 ],
    [1, 0, 0 ]
];


rows = len(pattern);
cols = len(pattern[0]);

calculated_w = (cols - 1) * base_skip_x + 2 * margin_x;
plate_w = calculated_w > outer_w ? calculated_w : outer_w;

plate_h = (rows - 1) * base_skip_y + 2 * margin_y;
screw_band_h = axis_h - plate_h / 2;

translate([-plate_w /2, 0, 0])
{
    translate([0, screw_band_h, 0])
        difference() {
            cube ([plate_w, plate_h, thickness]);

            translate([(plate_w + (cols - 1) * base_skip_x) / 2 , margin_y + (rows - 1) * base_skip_y, 0])
                mirror([1, 0, 0])
                    sieve();
        }
    screw_band(screw_band_h, screw_holes);
}
bottom(25);

rim_t = 2;
rim_l = plate_h + screw_band_h;
rim_h = 2;

translate([plate_w / 2 - rim_t,0,thickness])
    side_rim(rim_t, rim_l, rim_h);

translate([-plate_w / 2,0,thickness])
    side_rim(rim_t, rim_l, rim_h);

module sieve() {
    for (y = [0 : rows - 1])
        for (x = [0 : cols - 1])
        {
            if (pattern[y][x] == 1)
                translate([x * base_skip_x, - y * base_skip_y, thickness / 2])
                    cylinder(r=led_r, h=thickness + 2 * eps, center=true);
        }
}

module screw_band(height, cut_screw_holes = true) {
    difference() {
        cube([plate_w, height, thickness], false);

        if (cut_screw_holes)
        {
            translate([plate_w / 2 + screw_w / 2, screw_d / 2 + screw_bottom_margin, 0])
                cylinder(r=screw_d / 2, h= 3* thickness, center=true);

            translate([plate_w / 2 - screw_w / 2, screw_d / 2 + screw_bottom_margin, 0])
                cylinder(r=screw_d / 2, h= 3* thickness, center=true);
        }
    }
}