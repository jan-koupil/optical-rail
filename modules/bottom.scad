include <..\config\config.scad>

module tooth(depth) {
    linear_extrude(height=depth, center=false, convexity=10, twist=0) {
        polygon(points=[
            [0,             0],
            [0,             lock_in_h],
            [-lock_tooth_w, lock_in_h],
            [-lock_tooth_w, lock_in_h + lock_tooth_h],
            [0,             lock_out_h],
            [lock_t,        lock_out_h],
            [lock_t,        0]
        ]);
    }
}

module bottom_platform(depth){
    linear_extrude(height=depth, center=false, convexity=10, twist=0) {
        square(size=[inner_w + 2 * lock_t, bottom_platform_h], center=false);
    }
}

module bottom(depth, center = true) {
    wShift = center ? -inner_w /2 - lock_t : 0;
    translate([wShift, -bottom_platform_h, 0])
        mirror([0,1,0]) {

            translate([0, -bottom_platform_h, 0])
                bottom_platform(depth);

            translate([inner_w + lock_t, 0, 0])
                tooth(depth);

            translate([lock_t, 0, 0])
                mirror([1, 0, 0])
                    tooth(depth);    

        }
}

//bottom(20, center = false);