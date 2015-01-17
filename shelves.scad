
use <boxjoint.scad>;
use <kerf.scad>;
use <params.scad>;

$params = [
	["num_shelves",        3],
	["dimensions",         [150, 80, 70]],
	["foot_height",        20],
	["head_height",        30],
	["head_curve_height",  30],
	["finger_length",      10],
	["kerf",               0],
	["thickness",          3.175],
	["spacing",            20],
];

module shelf_side(dimensions, num_shelves) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value("thickness");
	foot_height = param_value("foot_height");
	head_height = param_value("head_height");
	head_curve_height = param_value("head_curve_height");

	shelves_height = (height + thickness) * (num_shelves - 1) + thickness
	               + foot_height + head_height;

	difference() {
		union() {
			square([depth, shelves_height]);
			translate([depth / 2, shelves_height])
				scale([1, head_curve_height * 2 / depth, 1])
					circle(depth / 2);
		}
		for (i = [0:num_shelves-1]) {
			translate([0, foot_height + i * (height + thickness)])
				box_joint_inner(depth);
		}
	}
}

module shelves(dimensions, num_shelves) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value("thickness");
	spacing = param_value("spacing");

	translate([spacing, spacing])
		shelf_side(dimensions, num_shelves);
	translate([depth + spacing * 2, spacing])
		shelf_side(dimensions, num_shelves);

	for (i = [0:num_shelves-1]) {
		translate([depth * 2 + spacing * 3,
		           i * (depth + spacing) + spacing])
			box_face([width + thickness * 2, depth],
			         ["none", "outer", "none", "outer"]);
	}
}

kerf_apply() {
	shelves(param_value("dimensions"), param_value("num_shelves"));
}

