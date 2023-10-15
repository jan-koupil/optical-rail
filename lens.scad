use <modules\lens.module.scad>;

$fn = 150; //large value means "rounder" circles and larger file sizes
lens_d = 40; //lens diameter
rail_length = 25;

lens_rail(lens_d / 2, rail_length);