include <..\config\config.scad>

module side_rim(height, length, thickness)
{
    cube([thickness, length - height, height]);

    //upper round
    translate([0, length - height, 0])
    intersection() {
        cube([thickness, height, height]);

        translate([thickness / 2, 0, 0])
            rotate([0, 90, 00])
                cylinder(r=height, h=thickness, center=true);        
    }

    //lower round
    translate([0, 0, height])
        difference() {
            cube([thickness, height, height]);

            translate([(thickness + eps) / 2, height, height])
                rotate([0, 90, 00])
                    cylinder(r=height, h=thickness + 2 * eps, center=true);        
        }
}