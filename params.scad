
// Default values used for various common parameters, if they are not
// specified by the user.
param_defaults = [
	// Kerf size (diameter of the laser beam width)
	["kerf",                  0],

	// Type of kerf to apply: straight, rounded or chamfered.
	["kerf_type",             "straight"],

	// Thickness of the material being cut.
	["thickness",             3.175],

	// Length of fingers used in box joints.
	["finger_length",         10],

	// Radius of rounding used on corners of box joint fingers.
	// A value of zero gives a square edge.
	["finger_rounding",       0],

	// Amount of detail used when drawing circles ($fn= value).
	["circle_detail",         50],

	// Spacing between parts when laying out a page.
	["spacing",               20],
];

// Look up the default value of a parameter by name.
function _param_default_value(name, i, fallback) =
	(i >= len(param_defaults)) ? fallback :
	(param_defaults[i][0] == name) ? param_defaults[i][1] :
	_param_default_value(name, i + 1, fallback);

function _param_value(params, name, i, fallback=undef) =
	(i >= len(params)) ? _param_default_value(name, 0, fallback) :
	(params[i][0] == name) ? params[i][1] :
	_param_value(params, name, i + 1, fallback);

// Look up the value of a parameter from a parameters list by name.
function param_value(params, name, fallback=undef) =
	_param_value(params, name, 0, fallback);

