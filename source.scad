$fn = 50;

led_r = 1.5;
margin_y = 5;
margin_x = 5;
base_skip_x = 5;
base_skip_y = 7;
thickness = 2;
eps = 0.05;

pattern = [
    [1, 1, 1, 1 ],
    [1, 0, 0, 0 ],
    [1, 1, 1, 0 ],
    [1, 0, 0, 0 ],
    [1, 1, 0 ,0 ]
];


rows = len(pattern);
cols = len(pattern[0]);

plate_w = (cols - 1) * base_skip_x + 2 * margin_x;
plate_h = (rows - 1) * base_skip_y + 2 * margin_y;

difference() {
    cube ([plate_w, plate_h, thickness]);

    translate([margin_x, margin_y + (rows - 1) * base_skip_y, 0])
        sieve();
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