
use <params.scad>;

// Get the minimum margin size (space between the edge and the length
// containing the main "fingers"). The actual margin will usually be
// slightly larger than the minimum. We default to twice the material
// thickness, as we want to avoid an area that may be cut off by
// another edge.
function box_joint_min_margin(params) =
	param_value(params, "thickness") * 2;

// Calculate the number of fingers to put on an edge (both inner and
// outer). The number of fingers is always odd, so that the joint is
// symmetrical. Finger size is fixed and specified by a parameter so
// that it is consistent across joints; we adjust the margin so that
// we get different numbers of fingers.
function box_joint_num_fingers(length, finger_len, min_margin) =
	1 + 2 * floor((length - min_margin * 2 - finger_len)
	      / (finger_len * 2));

// Calculate the actual margin, given the minimum margin. Actual
// margin will almost always be greater than the minimum, depending on
// how many fingers are in the joint.
function box_joint_actual_margin(length, finger_len, min_margin) =
	(length - box_joint_num_fingers(length, finger_len, min_margin)
	        * finger_len) / 2;

// Draw the inner part of a box joint of the given length, according
// to the provided parameters. Edges are square; this just draws
// rectangles in a line.
module box_joint_inner(length, params=[]) {
	thickness = param_value(params, "thickness");
	finger_len = param_value(params, "finger_length");

	min_margin = box_joint_min_margin(params);
	num_fingers = box_joint_num_fingers(length, finger_len, min_margin);
	margin = box_joint_actual_margin(length, finger_len, min_margin);

	for (i = [0:num_fingers - 1]) {
		if ((i % 2) == 0) {
			translate([margin + i * finger_len, 0]) {
				square([finger_len, thickness]);
			}
		}
	}
}

// Draw the outer part of a box joint of the given length. The result
// is complementary to what box_joint_inner() draws; combined together
// they give a continuous rectangle of length 'length'.
module box_joint_outer(length, params=[]) {
	thickness = param_value(params, "thickness");
	difference() {
		square([length, thickness]);
		box_joint_inner(length, params);
	}
}

// Draw a rectangle with rounded edges of the given dimensions.
// 'radius' is the radius of the rounded edge; this will be limited
// if it is too large relative to the rectangle's dimensions. 'fn'
// controls the detail of the rounding.
module roundrect(dimensions, radius, fn=undef) {
	width = dimensions[0]; depth = dimensions[1];

	// Limit radius to half the minimum of the width and depth.
	_radius = min([radius, width / 2, depth / 2]);

	union() {
		translate([_radius, _radius])
			circle(_radius, $fn=fn);
		translate([width - _radius, _radius])
			circle(_radius, $fn=fn);
		translate([width - _radius, depth - _radius])
			circle(_radius, $fn=fn);
		translate([_radius, depth - _radius])
			circle(_radius, $fn=fn);
		translate([_radius, 0])
			square([width - _radius * 2, depth]);
		translate([0, _radius])
			square([width, depth - _radius * 2]);
	}
}

// Draw a mask for rounding an edge joint. This draws all the fingers
// of a box joint together as roundrects; taking the intersection of
// this and a box_joint_{inner,outer} gives a box joint with rounded
// edges.
module box_edge_rounding_mask(length, params=[]) {
	thickness = param_value(params, "thickness");
	finger_len = param_value(params, "finger_length");
	radius = param_value(params, "finger_rounding");
	fn = param_value(params, "circle_detail");

	min_margin = box_joint_min_margin(params);
	num_fingers = box_joint_num_fingers(length, finger_len, min_margin);
	margin = box_joint_actual_margin(length, finger_len, min_margin);

	intersection() {
		square([length, thickness]);
		union() {
			roundrect([margin, thickness * 2], radius, fn=fn);

			for (i = [0:num_fingers - 1]) {
				translate([margin + i * finger_len, 0]) {
					roundrect([finger_len, thickness * 2],
					          radius, fn=fn);
				}
			}

			translate([length - margin, 0])
				roundrect([margin, thickness * 2], radius,
				          fn=fn);
		}
	}
}

// Draw the inner edge of a box face, applying a rounding mask to give
// rounded edges.
module box_edge_joint_inner(length, params=[]) {
	thickness = param_value(params, "thickness");

	// Remember that we are working backwards in drawing what we
	// want to cut away from the box face. So we must actually
	// draw the inversion of a rounded outer edge.
	difference() {
		square([length, thickness]);
		intersection() {
			box_edge_rounding_mask(length, params);
			box_joint_outer(length, params);
		}
	}
}

// Draw the outers edge of a box face, applying a rounding mask to give
// rounded edges.
module box_edge_joint_outer(length, params=[]) {
	thickness = param_value(params, "thickness");

	difference() {
		square([length, thickness]);
		intersection() {
			box_edge_rounding_mask(length, params);
			box_joint_inner(length, params);
		}
	}
}

// A "full" joint is the opposite of a "none" joint: while a "none"
// joint is a null operation that cuts nothing, a "full" joint cuts off
// the entire area where there would be a joint.
module box_joint_full(length, params=[]) {
	thickness = param_value(params, "thickness");
	square([length, thickness]);
}

// Draw a box joint on the edge of a box face, of the given length
// and type. Valid joint types are:
//  'none': a null type that cuts nothing away
//  'full': complement to null that cuts the entire region of the
//          joint away.
//  'inner': side of a box joint that fingers are inserted into.
//  'outer': side of the box joint with the fingers that are inserted
//           into the 'inner' joint type.
module box_edge_joint_of_type(length, joint_type, params=[]) {
	if (joint_type == "none") {
		// ... do nothing
	} else if (joint_type == "full") {
		box_joint_full(length, params);
	} else if (joint_type == "inner") {
		box_edge_joint_inner(length, params);
	} else {
		box_edge_joint_outer(length, params);
	}
}

// Draw a box joint on the edge of a box face, on the given edge and
// of the given type. Valid edges are: 'top', 'bottom', 'left',
// 'right'.
module box_joint_for_edge(dimensions, edge="left", joint_type="inner",
                          params=[]) {
	if (edge == "top") {
		translate(dimensions) rotate(180)
			box_edge_joint_of_type(dimensions[0], joint_type,
			                       params);
	} else if (edge == "bottom") {
		box_edge_joint_of_type(dimensions[0], joint_type, params);
	} else if (edge == "left") {
		translate([0, dimensions[1]]) rotate(270)
			box_edge_joint_of_type(dimensions[1], joint_type,
			                       params);
	} else if (edge == "right") {
		translate([dimensions[0], 0]) rotate(90)
			box_edge_joint_of_type(dimensions[1], joint_type,
			                       params);
	}
}

// Draw a complete rectangular side of a box, where the side has the
// specified 2D dimensions. 'edges' is a list with four entries, one
// for each edge of the rectangle to specify the type of joint to
// use on each edge (clockwise from top edge).
module box_face(dimensions, edges, params=[]) {
	difference() {
		square(dimensions);
		union() {
			box_joint_for_edge(dimensions, "top", edges[0],
			                   params);
			box_joint_for_edge(dimensions, "right", edges[1],
			                   params);
			box_joint_for_edge(dimensions, "bottom", edges[2],
			                   params);
			box_joint_for_edge(dimensions, "left", edges[3],
			                   params);
		}
	}
}

// Given a particular joint type (of the types accepted by
// box_joint_for_edge(), return the complementary joint type that
// should be used on the joining face.
function box_joint_opposite(joint_type) =
	(joint_type == "inner") ? "outer" :
	(joint_type == "outer") ? "inner" :
	(joint_type == "none") ? "full" :
	(joint_type == "full") ? "none" :
	undef;

