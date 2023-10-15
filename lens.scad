include <config\config.scad>;
use <modules\lens.module.scad>;

/* config */
$fn = 150;
lens_r = 27;
rail_length = 25;

lens_rail(lens_r, rail_length);