include <config\config.scad>;
use <modules\bottom.scad>;

/* config */
$fn = 150;
lens_r = 27;
rail_length = 25;

/* no user-edit zone */
outer_r = lens_r + lens_rim; //outer radius

module lens_holder() {

    translate([0, outer_r, lens_holder_t / 2])
        difference() {
            union() {
                //around lens
                cylinder(r=outer_r, h=lens_holder_t, center=true);

                //lens lower block
                block_w = 2 * outer_r < outer_w ? 2 * outer_r : outer_w;
                translate([0, -outer_r/2, 0])
                    cube(size=[block_w, outer_r, lens_holder_t], center=true);
            }


            //inside cut
            union() {
                cylinder(r=lens_r, h=lens_holder_t + 2 * eps, center=true);

                translate([0, 0, collar_t])
                    cylinder(r=lens_r + collar_h, h=lens_holder_t, center=true);
            }
        }
}

lower_block_h = axis_h - outer_r;

if (outer_w / 2 - outer_r > 0)
    small_lens_low_block();

else
    large_lens_low_block();

module large_lens_low_block() {
        translate([ 0, lower_block_h, 0])
        lens_holder();
        //echo(str("Variable = ", lower_block_h));
        translate([-outer_w / 2, 0, 0])
            cube([outer_w, lower_block_h, lens_holder_t]);
}

module small_lens_low_block() {
    max_connecting_r = outer_w / 2 - outer_r;

    two_part = lower_block_h > max_connecting_r;
    // echo(str("Two part = ", two_part));
    straight_part_h = two_part ? lower_block_h - max_connecting_r : 0;
    // echo(str("str_part = ", straight_part_h));
    connecting_r = two_part ? max_connecting_r : lower_block_h;

    translate([0, lower_block_h, 0]) {

        lens_holder();

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
    }
}
//color("red", 0.3)
bottom(20, rail_length);