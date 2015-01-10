
use <params.scad>;

module kerf_apply(params=[]) {
	kerf = param_value(params, "kerf");
	kerf_type = param_value(params, "kerf_type");

	// Current versions of OpenSCAD don't have the offset() module
	// in the standard library, so if kerf=0 (the default) then
	// invoke the child block without calling offset.
	if (kerf <= 0) {
		children();
	} else if (kerf_type == "rounded") {
		offset(r=kerf/2) children();
	} else if (kerf_type == "chamfered") {
		offset(delta=kerf/2, chamfer=true) children();
	} else {
		offset(delta=kerf/2, chamfer=false) children();
	}
}

