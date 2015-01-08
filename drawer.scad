
use <boxjoint.scad>;

module drawer(dimensions, thickness, finger_len=undef, spacing=2) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];

	// Back
	translate([height + spacing, height + depth + spacing * 2])
		box_side([width, height], thickness, finger_len,
		         ["outer", "none", "inner", "inner"]);
	// Left side
	translate([0, height + spacing])
		box_side([height, depth], thickness, finger_len,
		         ["outer", "outer", "none", "outer"]);
	// Bottom
	translate([height + spacing, height + spacing])
		box_side([width, depth], thickness, finger_len,
		         ["inner", "inner", "inner", "inner"]);
	// Right side
	translate([width + height + spacing * 2, height + spacing])
		box_side([height, depth], thickness, finger_len,
		         ["outer", "outer", "outer", "none"]);
	// Front
	translate([height + spacing, height]) scale([1, -1, 1])
		box_side([width, height], thickness, finger_len,
		         ["outer", "none", "inner", "inner"]);
}

drawer([30, 15, 10], 1);

