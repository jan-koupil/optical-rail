include <config\config.scad>;
use <modules\bottom.module.scad>;
use <modules\side_rim.module.scad>;

$fn = 150; //large value means "rounder" circles and larger file sizes
lens_d = 53.3; //lens diameter
rail_length = 25;

//lens-ring params
lens_rim_t = 3; //lens rim thickness
lens_rim_h = 5; //forms depth of the lens block inside lens ring
lens_holder_t = 2;
collar_t = 1; //collar to keep lens vertically  - thickness
collar_d = 0.5; //                              - depth (tooth height)


/* End of config */

lens_rail(lens_d / 2, rail_length);

module lens_rail(lens_r, rail_length) {    

    outer_r = lens_r + lens_rim_t; //outer radius
    lower_block_h = axis_h - outer_r;

    if (outer_w / 2 - outer_r > 0)
        small_lens_low_block();
    else
        large_lens_low_block();

    bottom(rail_length, true);

    module lens_holder_block() {

        translate([0, outer_r, (lens_holder_t + lens_rim_h) / 2]) {
            //around lens
            cylinder(r=outer_r, h=lens_holder_t + lens_rim_h, center=true);

            //lens lower block
            block_w = 2 * outer_r < outer_w ? 2 * outer_r : outer_w;
            translate([0, -outer_r/2, -lens_rim_h / 2])
                cube(size=[block_w, outer_r, lens_holder_t], center=true);
        }
    }

    module lens_holder_cut() {

        translate([0, outer_r, (lens_holder_t + lens_rim_h) / 2]) {
            cylinder(r=lens_r - collar_d, h=lens_holder_t + lens_rim_h + 2 * eps, center=true);

            translate([0, 0, collar_t])
                cylinder(r=lens_r, h=lens_holder_t + lens_rim_h, center=true);
        }
    }

    module large_lens_low_block() {
        difference() {
            union() {
                translate([ 0, lower_block_h, 0])
                    lens_holder_block();
                //echo(str("Variable = ", lower_block_h));
                translate([-outer_w / 2, 0, 0])
                    cube([outer_w, lower_block_h, lens_holder_t]);

                rim_d = rail_length - lens_holder_t;
                rim_l = axis_h;

                translate([outer_w / 2 - rim_t, 0, lens_holder_t])
                    side_rim(rim_h, rim_l, rim_d, rim_t);

                translate([-outer_w / 2, 0, lens_holder_t])
                    side_rim(rim_h, rim_l, rim_d, rim_t);
            }
            translate([ 0, lower_block_h, 0])
                lens_holder_cut();
        }
    }

    module small_lens_low_block() {        
        max_connecting_r = outer_w / 2 - outer_r;

        two_part = lower_block_h > max_connecting_r;
        // echo(str("Two part = ", two_part));
        straight_part_h = two_part ? lower_block_h - max_connecting_r : 0;
        // echo(str("str_part = ", straight_part_h));
        connecting_r = two_part ? max_connecting_r : lower_block_h;

        translate([0, lower_block_h, 0]) {

            difference() {
                union() {
                    lens_holder_block();

                    // color("green", 0.3)
                    translate([-outer_r, -straight_part_h, 0])
                        cube(size=[2 * outer_r, straight_part_h, lens_holder_t], center=false);

                    difference() {
                        // color("lime", 0.3)
                        translate([-outer_r - connecting_r, -straight_part_h - connecting_r, 0])
                            cube(size=[2 * outer_r + 2 * connecting_r, connecting_r, lens_holder_t], center=false);

                        // color("blue", 0.3)
                        translate([-outer_r - connecting_r, -straight_part_h, 0])
                            cylinder(r=connecting_r + eps, h=30, center=true);

                        // color("blue", 0.3)
                        translate([+outer_r + connecting_r, -straight_part_h, 0])
                            cylinder(r=connecting_r + eps, h=30, center=true);
                    }

                    rim_d = rail_length - lens_holder_t;
                    rim_l = axis_h;

                    translate([outer_r - rim_t, -lower_block_h, lens_holder_t])
                        side_rim(rim_h, rim_l, rim_d, rim_t);

                    translate([-outer_r, -lower_block_h, lens_holder_t])
                        side_rim(rim_h, rim_l, rim_d, rim_t);
                }
                lens_holder_cut();
            }
        }
    }

}

