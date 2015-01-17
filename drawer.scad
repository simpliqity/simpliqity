
use <boxjoint.scad>;
use <kerf.scad>;
use <params.scad>;

$params = [
	["dimensions",         [150, 80, 70]],
	["finger_length",      10],
	["pull_hole_radius",   10],
	["kerf",               0],
	["thickness",          3.175],
	["spacing",            20],
];

module drawer(dimensions) {
	width = dimensions[0]; depth = dimensions[1]; height = dimensions[2];
	spacing = param_value("spacing");

	// These variables control the joint types used for every joint
	// on the drawer. The naming convention is: joint_{face}_{joint}.
	// For example, joint_bottom_front is the joint on the bottom
	// face that joins to the front face. If this is set to "inner",
	// that implies that the joint on the front face that joins to
	// the bottom becomes the opposite ("outer").
	joint_bottom_front = "inner";
	joint_bottom_back = "inner";
	joint_bottom_left = "inner";
	joint_bottom_right = "inner";
	joint_front_left = "inner";
	joint_front_right = "inner";
	joint_back_left = "inner";
	joint_back_right = "inner";

	joint_front_bottom = box_joint_opposite(joint_bottom_front);
	joint_back_bottom = box_joint_opposite(joint_bottom_back);
	joint_left_bottom = box_joint_opposite(joint_bottom_left);
	joint_right_bottom = box_joint_opposite(joint_bottom_right);
	joint_left_front = box_joint_opposite(joint_front_left);
	joint_right_front = box_joint_opposite(joint_front_right);
	joint_left_back = box_joint_opposite(joint_back_left);
	joint_right_back = box_joint_opposite(joint_back_right);

	// Back
	translate([height + spacing * 2, height + depth + spacing * 3])
		box_face([width, height], ["none", joint_back_right,
		         joint_back_bottom, joint_back_left]);
	// Left side
	translate([spacing, height + spacing * 2])
		box_face([height, depth], [joint_left_back, joint_left_bottom,
		         joint_left_front, "none"]);
	// Bottom
	translate([height + spacing * 2, height + spacing * 2])
		box_face([width, depth], [joint_bottom_back,
		         joint_bottom_right, joint_bottom_front,
		         joint_bottom_back]);
	// Right side
	translate([height + width + spacing * 3, height + spacing * 2])
		box_face([height, depth], [joint_right_back, "none",
		         joint_right_front, joint_right_bottom]);
	// Front
	translate([height + spacing * 2, spacing]) {
		difference() {
			box_face([width, height], [joint_front_bottom,
			         joint_front_right, "none", joint_front_left]);
			translate([width / 2, height / 2])
				circle(param_value("pull_hole_radius"),
				       $fn=param_value("circle_detail"));
		}
	}
}

kerf_apply() {
	drawer(param_value("dimensions"));
}

