
module box_joint_inner(length, thickness, finger_len=undef, margin=undef) {
	_margin = margin == undef ? thickness * 2 : margin;
	_finger_len = finger_len == undef ? thickness * 3 : finger_len;

	num_fingers =
		1 + 2 * floor((length - _margin * 2 - _finger_len) 
		  / (_finger_len * 2));
	finger_space_len = num_fingers * _finger_len;
	actual_margin = (length - finger_space_len) / 2;

	for (i = [0:num_fingers - 1]) {
		if ((i % 2) == 0) {
			translate([actual_margin + i * _finger_len, 0])
				square([_finger_len, thickness]);
		}
	}
}

module box_joint_outer(length, thickness, finger_len=undef, margin=undef) {
	difference() {
		square([length, thickness]);
		box_joint_inner(length, thickness, finger_len, margin);
	}
}

module box_joint_of_type(length, thickness, finger_len, joint_type) {
	if (joint_type == "none") {
		// ... do nothing
	} else if (joint_type == "inner") {
		box_joint_inner(length, thickness, finger_len);
	} else {
		box_joint_outer(length, thickness, finger_len);
	}
}

module box_joint_for_side(dimensions, thickness, finger_len, side="left",
                          type="inner") {
	if (side == "top") {
		translate(dimensions) rotate(180)
			box_joint_of_type(dimensions[0], thickness,
			                  finger_len, type);
	} else if (side == "bottom") {
		box_joint_of_type(dimensions[0], thickness, finger_len, type);
	} else if (side == "left") {
		translate([0, dimensions[1]]) rotate(270)
			box_joint_of_type(dimensions[1], thickness,
			                  finger_len, type);
	} else if (side == "right") {
		translate([dimensions[0], 0]) rotate(90)
			box_joint_of_type(dimensions[1], thickness,
			                  finger_len, type);
	}
}

module box_side(dimensions, thickness, finger_len, sides) {
	difference() {
		square(dimensions);
		union() {
			box_joint_for_side(dimensions, thickness, finger_len,
			                   "bottom", sides[0]);
			box_joint_for_side(dimensions, thickness, finger_len,
			                   "top", sides[1]);
			box_joint_for_side(dimensions, thickness, finger_len,
			                   "left", sides[2]);
			box_joint_for_side(dimensions, thickness, finger_len,
			                   "right", sides[3]);
		}
	}
}


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

module shelf_side(dimensions, thickness, num_shelves, finger_len) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];

	shelves_height = (height + thickness) * num_shelves + thickness;

	difference() {
		square([depth, shelves_height]);
		for (i = [0:num_shelves]) {
			translate([0, i * (height + thickness)])
				box_joint_inner(depth, thickness, finger_len);
		}
	}
}

module shelves(dimensions, thickness, num_shelves, finger_len=undef, spacing=2) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];

	shelf_side(dimensions, thickness, num_shelves, finger_len);
	translate([depth + spacing, 0])
		shelf_side(dimensions, thickness, num_shelves, finger_len);

	for (i = [0:num_shelves]) {
		translate([depth * 2 + spacing * 2, i * (depth + spacing)])
			box_side([width + thickness * 2, depth], thickness, finger_len,
			         ["none", "none", "inner", "inner"]);
	}
}

box([30, 15, 10], 1);
//drawer([30, 15, 10], 1);
//shelves([30, 15, 20], 1, 3, 2);

