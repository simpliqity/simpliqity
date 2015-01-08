
use <boxjoint.scad>;

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

shelves([30, 15, 20], 1, 3, 2);

