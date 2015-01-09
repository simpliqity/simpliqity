use <boxjoint.scad>;
use <params.scad>;

params = [
	["num_shelves",        10],
	["width",              16],
	["depth",              20],
	["height",             3],
	["thickness",          1],
	["spacing",            2],
	["tab_inset",          2],
	["tab_length",         3],
	["tab_depth",          2],
	["tab_flange",         0.5],
];

module tower_side(num_shelves, dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value(params, "thickness");
	tab_length = param_value(params, "tab_length");
	tab_inset = param_value(params, "tab_inset");

	tower_height = num_shelves * (height + thickness)
	             + thickness;

	difference() {
		box_side([depth + thickness, tower_height],
		         ["inner", "inner", "none", "outer"],
		         params);

		for (i = [1:num_shelves-1]) {
			translate([tab_inset, i * (height + thickness)])
				square([tab_length, thickness]);
			translate([depth - tab_inset - tab_length,
			           i * (height + thickness)])
				square([tab_length, thickness]);
		}
	}
}

module tower_back(num_shelves, dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value(params, "thickness");

	tower_height = num_shelves * (height + thickness)
	             + thickness;

	box_side([width + thickness * 2, tower_height],
	         ["inner", "inner", "inner", "inner"],
	         params);
}

module shelf_tab(params) {
	thickness = param_value(params, "thickness");
	tab_length = param_value(params, "tab_length");
	tab_depth = param_value(params, "tab_depth");
	tab_flange = param_value(params, "tab_flange");

	union() {
		translate([0, tab_flange])
			square([thickness, tab_length]);

		translate([thickness, 0]) {
			scale([tab_depth, tab_flange + tab_length / 2]) {
				intersection() {
					translate([0, 1]) scale([1 / 10, 1 / 10]) circle(10);
					translate([0, 0]) square([1, 2]);
				}
			}
		}
	}
}

module tower(num_shelves, dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	thickness = param_value(params, "thickness");
	spacing = param_value(params, "spacing");
	tab_length = param_value(params, "tab_length");
	tab_depth = param_value(params, "tab_depth");
	tab_flange = param_value(params, "tab_flange");

	// Left side:
	tower_side(num_shelves, dimensions, params);

	// Back:
	translate([depth + thickness + spacing, 0])
		tower_back(num_shelves, dimensions, params);

	// Right side:
	translate([width + depth * 2 + thickness * 4 + spacing * 2, 0])
		scale([-1, 1, 1])
			tower_side(num_shelves, dimensions, params);

	// Top and bottom:
	translate([width + depth * 2 + thickness * 4 + spacing * 3, 0]) {
		box_side([width + thickness, depth + thickness],
	         ["none", "outer", "outer", "outer"],
	         params);
		translate([0, depth + thickness + spacing])
			box_side([width + thickness, depth + thickness],
			         ["none", "outer", "outer", "outer"],
			         params);
	}

	// Tabs
	translate([width * 2 + depth * 2 + thickness * 6 + spacing * 4, 0]) {
		for (i = [0:num_shelves-1]) {
			translate([0, i * (tab_length + tab_flange * 2 + spacing)]) {
				shelf_tab(params);
				translate([tab_depth + thickness + spacing, 0])
					shelf_tab(params);
			}
		}
	}
}

tower(param_value(params, "num_shelves"),
      [param_value(params, "width"), param_value(params, "depth"),
       param_value(params, "height")], params);
