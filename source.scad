include <config\config.scad>;
use <modules\bottom.module.scad>;
use <modules\side_rim.module.scad>;

$fn = 50;

thickness = 2;
rail_length = 25;

/* LED area */
led_r = 1.75;
margin_y = 8;
margin_x = 5;
base_skip_x = 10;
base_skip_y = 10;

pattern = [
    [1, 1, 1 ],
    [1, 0, 0 ],
    [1, 1, 0 ],
    [1, 0, 0 ],
    [1, 0, 0 ]
];

/* power screws source params */
cut_screw_holes = false;
screw_d = 3; //connecting screw diamater
screw_w = 30; //screw holes separation
screw_bottom_margin = 5; //connecting screw hole from bottom distnace

/* Power back */
add_power_back = true;
back_h = 15;
connector_r = 4.2;
connector_shift = 4;

/* Power switch */
sw_l = 17;
sw_d = 8.2; //7.8
sw_out = 23.5;
sw_t = 0.6;
sw_hole_sep = 20;
sw_screw_h = 5;
sw_screw_r = 1 / 2; //2
full_cut = 10; //cokoliv


/* end of config */


light_source();

module light_source()
{
    rows = len(pattern);
    cols = len(pattern[0]);

    calculated_w = (cols - 1) * base_skip_x + 2 * margin_x;
    plate_w = calculated_w > outer_w ? calculated_w : outer_w;

    plate_h = (rows - 1) * base_skip_y + 2 * margin_y;
    bottom_band_h = axis_h - plate_h / 2;

    translate([-plate_w /2, 0, 0])
    {
        translate([0, bottom_band_h, 0])
            difference() {
                cube ([plate_w, plate_h, thickness]);

                translate([(plate_w + (cols - 1) * base_skip_x) / 2 , margin_y + (rows - 1) * base_skip_y, 0])
                    mirror([1, 0, 0])
                        sieve();
            }
        bottom_band(bottom_band_h, cut_screw_holes);
    }
    bottom(rail_length);


    rim_l = plate_h + bottom_band_h;
    rim_d = rail_length - thickness;


    translate([plate_w / 2 - rim_t,0,thickness])
        side_rim(rim_h, rim_l, rim_d, rim_t);

    translate([-plate_w / 2,0,thickness])
        side_rim(rim_h, rim_l, rim_d, rim_t);

    if (add_power_back) {
        translate([-plate_w / 2,0,rail_length - thickness])
            power_back();
    }

    module sieve() {
        for (y = [0 : rows - 1])
            for (x = [0 : cols - 1])
            {
                if (pattern[y][x] == 1)
                    translate([x * base_skip_x, - y * base_skip_y, thickness / 2])
                        cylinder(r=led_r, h=thickness + 2 * eps, center=true);
            }
    }

    module bottom_band(height, cut_screw_holes = true) {
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

    module power_back() {

        connector_h = back_h / 2;
        connector_x = plate_w - connector_r - connector_shift;

        difference() {
            cube ([plate_w, back_h, thickness]);
            translate([connector_x, connector_h, -eps])
            cylinder(r=connector_r, h=thickness + 2 * eps, center=false);

            translate([sw_out / 2 + rim_t + 1, connector_h, sw_t + thickness])
                switch();
        }

        translate([0,0,0]) mirror([0, 0, 1])            
            side_rim(rim_h, back_h, rim_d, rim_t);

        translate([plate_w - rim_t, 0, 0]) mirror([0, 0, 1])            
            side_rim(rim_h, back_h, rim_d, rim_t);


    }

    module switch() {
        translate([0,0,-sw_t]) {
            translate([0,0,-full_cut / 2 + sw_t])
                cube([sw_l, sw_d, full_cut], center=true);
            translate([0,0,sw_t / 2])
                cube([sw_out, sw_d, sw_t], center=true);
            translate([sw_hole_sep / 2,0 , sw_t - sw_screw_h])
                cylinder(r=sw_screw_r, h=sw_screw_h, center=false);
            translate([-sw_hole_sep / 2,0 , sw_t - sw_screw_h])
                cylinder(r=sw_screw_r, h=sw_screw_h, center=false);
        }
    }
}



