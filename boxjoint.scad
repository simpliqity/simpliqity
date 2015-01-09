
use <params.scad>;

module box_joint_inner(length, params=[], margin=undef) {
	thickness = param_value(params, "thickness");
	finger_len = param_value(params, "finger_length");
	_margin = margin == undef ? thickness * 2 : margin;

	num_fingers =
		1 + 2 * floor((length - _margin * 2 - finger_len)
		  / (finger_len * 2));
	finger_space_len = num_fingers * finger_len;
	actual_margin = (length - finger_space_len) / 2;

	for (i = [0:num_fingers - 1]) {
		if ((i % 2) == 0) {
			translate([actual_margin + i * finger_len, 0])
				square([finger_len, thickness]);
		}
	}
}

module box_joint_outer(length, params=[], margin=undef) {
	thickness = param_value(params, "thickness");
	difference() {
		square([length, thickness]);
		box_joint_inner(length, params, margin);
	}
}

// A "full" joint is the opposite of a "none" joint: while a "none"
// joint is a null operation that cuts nothing, a "full" joint cuts off
// the entire area where there would be a joint.
module box_joint_full(length, params=[]) {
	thickness = param_value(params, "thickness");
	square([length, thickness]);
}

module box_joint_of_type(length, joint_type, params=[]) {
	if (joint_type == "none") {
		// ... do nothing
	} else if (joint_type == "full") {
		box_joint_full(length, params);
	} else if (joint_type == "inner") {
		box_joint_inner(length, params);
	} else {
		box_joint_outer(length, params);
	}
}

module box_joint_for_side(dimensions, side="left", joint_type="inner",
                          params=[]) {
	if (side == "top") {
		translate(dimensions) rotate(180)
			box_joint_of_type(dimensions[0], joint_type, params);
	} else if (side == "bottom") {
		box_joint_of_type(dimensions[0], joint_type, params);
	} else if (side == "left") {
		translate([0, dimensions[1]]) rotate(270)
			box_joint_of_type(dimensions[1], joint_type, params);
	} else if (side == "right") {
		translate([dimensions[0], 0]) rotate(90)
			box_joint_of_type(dimensions[1], joint_type, params);
	}
}

module box_side(dimensions, sides, params=[]) {
	difference() {
		square(dimensions);
		union() {
			box_joint_for_side(dimensions, "bottom", sides[0],
			                   params);
			box_joint_for_side(dimensions, "top", sides[1],
			                   params);
			box_joint_for_side(dimensions, "left", sides[2],
			                   params);
			box_joint_for_side(dimensions, "right", sides[3],
			                   params);
		}
	}
}

function box_joint_opposite(joint_type) =
	(joint_type == "inner") ? "outer" :
	(joint_type == "outer") ? "inner" :
	(joint_type == "none") ? "full" :
	(joint_type == "full") ? "none" :
	undef;

