
use <boxjoint.scad>;

module box(dimensions, thickness, finger_len=undef, spacing=2) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];

	// Top
	translate([height + spacing, height * 2 + depth + spacing * 3])
		box_side([width, depth], thickness, finger_len,
		         ["inner", "inner", "inner", "inner"]);
	// Back
	translate([height + spacing, height + depth + spacing * 2])
		box_side([width, height], thickness, finger_len,
		         ["outer", "outer", "inner", "inner"]);
	// Bottom
	translate([height + spacing, height + spacing])
		box_side([width, depth], thickness, finger_len,
		         ["inner", "inner", "inner", "inner"]);
	// Front
	translate([height + spacing, 0])
		box_side([width, height], thickness, finger_len,
		         ["outer", "outer", "inner", "inner"]);
	// Left side
	translate([0, height + spacing])
		box_side([height, depth], thickness, finger_len,
		         ["outer", "outer", "outer", "outer"]);
	// Right side
	translate([height + width + spacing * 2, height + spacing])
		box_side([height, depth], thickness, finger_len,
		         ["outer", "outer", "outer", "outer"]);
}


box([30, 15, 10], 1);

