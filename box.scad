
use <boxjoint.scad>;
use <kerf.scad>;
use <params.scad>;

params = [
	["dimensions",          [150, 80, 70]],
	["finger_length",       10],
	["finger_rounding",     0],
	["kerf",                0],
	["thickness",           3.175],
	["spacing",             20],
];

module box(dimensions, params=[]) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	spacing = param_value(params, "spacing");

	// These variables control the joint types used for every joint
	// on the box. The naming convention is: joint_{face}_{joint}.
	// For example, joint_bottom_front is the joint on the bottom
	// face that joins to the front face. If this is set to "inner",
	// that implies that the joint on the front face that joins to
	// the bottom becomes the opposite ("outer").
	joint_bottom_front = "inner";
	joint_bottom_back = "inner";
	joint_bottom_left = "inner";
	joint_bottom_right = "inner";
	joint_top_front = "inner";
	joint_top_back = "inner";
	joint_top_left = "inner";
	joint_top_right = "inner";
	joint_front_left = "inner";
	joint_front_right = "inner";
	joint_back_left = "inner";
	joint_back_right = "inner";

	joint_front_bottom = box_joint_opposite(joint_bottom_front);
	joint_back_bottom = box_joint_opposite(joint_bottom_back);
	joint_left_bottom = box_joint_opposite(joint_bottom_left);
	joint_right_bottom = box_joint_opposite(joint_bottom_right);
	joint_front_top = box_joint_opposite(joint_top_front);
	joint_back_top = box_joint_opposite(joint_top_back);
	joint_left_top = box_joint_opposite(joint_top_left);
	joint_right_top = box_joint_opposite(joint_top_right);
	joint_left_front = box_joint_opposite(joint_front_left);
	joint_right_front = box_joint_opposite(joint_front_right);
	joint_left_back = box_joint_opposite(joint_back_left);
	joint_right_back = box_joint_opposite(joint_back_right);

	// Top
	translate([height + spacing * 2, height * 2 + depth + spacing * 4])
		box_side([width, depth], [joint_top_back, joint_top_front,
		         joint_top_left, joint_top_right], params);
	// Back
	translate([height + spacing * 2, height + depth + spacing * 3])
		box_side([width, height], [joint_back_bottom,
		         joint_back_top, joint_back_left, joint_back_right],
		         params);
	// Bottom
	translate([height + spacing * 2, height + spacing * 2])
		box_side([width, depth], [joint_bottom_front,
		         joint_bottom_back, joint_bottom_left,
		         joint_bottom_right], params);
	// Front
	translate([height + spacing * 2, spacing])
		box_side([width, height], [joint_front_top, joint_front_bottom,
		         joint_front_left, joint_front_right], params);
	// Left side
	translate([spacing, height + spacing * 2])
		box_side([height, depth], [joint_left_front, joint_left_back,
		         joint_left_top, joint_left_bottom], params);
	// Right side
	translate([height + width + spacing * 3, height + spacing * 2])
		box_side([height, depth], [joint_right_front, joint_right_back,
		         joint_right_bottom, joint_right_top], params);
}

kerf_apply(params) {
	box(param_value(params, "dimensions"), params);
}

