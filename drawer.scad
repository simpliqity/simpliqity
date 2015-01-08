
use <boxjoint.scad>;
use <params.scad>;

params = [
	["width",            30],
	["depth",            15],
	["height",           10],
	["finger_length",    2],
	["spacing",          2],
];

module drawer(dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	spacing = param_value(params, "spacing");

	// Back
	translate([height + spacing, height + depth + spacing * 2])
		box_side([width, height], ["outer", "none", "inner", "inner"],
		         params);
	// Left side
	translate([0, height + spacing])
		box_side([height, depth], ["outer", "outer", "none", "outer"],
		         params);
	// Bottom
	translate([height + spacing, height + spacing])
		box_side([width, depth], ["inner", "inner", "inner", "inner"],
		         params);
	// Right side
	translate([width + height + spacing * 2, height + spacing])
		box_side([height, depth], ["outer", "outer", "outer", "none"],
		         params);
	// Front
	translate([height + spacing, 0])
		box_side([width, height], ["none", "outer", "inner", "inner"],
		         params);
}

drawer([param_value(params, "width"), param_value(params, "depth"),
        param_value(params, "height")], params);

