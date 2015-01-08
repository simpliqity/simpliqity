
// Default values used for various common parameters, if they are not
// specified by the user.
param_defaults = [
	// Thickness of the material being cut.
	["thickness",             1],

	// Length of fingers used in box joints.
	["finger_length",         2],

	// Spacing between parts when laying out a page.
	["spacing",               2],
];

// Look up the default value of a parameter by name.
function _param_default_value(name, i) =
	(i >= len(param_defaults)) ? undef :
	(param_defaults[i][0] == name) ? param_defaults[i][1] :
	_param_default_value(name, i + 1);

function _param_value(params, name, i) =
	(i >= len(params)) ? _param_default_value(name, 0) :
	(params[i][0] == name) ? params[i][1] :
	_param_value(params, name, i + 1);

// Look up the value of a parameter from a parameters list by name.
function param_value(params, name) =
	_param_value(params, name, 0);

