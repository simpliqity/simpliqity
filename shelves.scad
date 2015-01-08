
use <boxjoint.scad>;
use <params.scad>;

params = [
	["num_shelves",      3],
	["width",            30],
	["depth",            15],
	["height",           10],
	["finger_length",    2],
	["spacing",          2],
];

module shelf_side(dimensions, num_shelves, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value(params, "thickness");

	shelves_height = (height + thickness) * num_shelves + thickness;

	difference() {
		square([depth, shelves_height]);
		for (i = [0:num_shelves]) {
			translate([0, i * (height + thickness)])
				box_joint_inner(depth, params);
		}
	}
}

module shelves(dimensions, num_shelves, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value(params, "thickness");
	spacing = param_value(params, "spacing");

	shelf_side(dimensions, num_shelves, params);
	translate([depth + spacing, 0])
		shelf_side(dimensions, num_shelves, params);

	for (i = [0:num_shelves]) {
		translate([depth * 2 + spacing * 2, i * (depth + spacing)])
			box_side([width + thickness * 2, depth],
			         ["none", "none", "outer", "outer"],
			         params);
	}
}

shelves([param_value(params, "width"), param_value(params, "depth"),
         param_value(params, "height")],
	param_value(params, "num_shelves"), params);

