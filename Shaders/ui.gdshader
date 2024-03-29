shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.0,0.0,0.0);
	if (FRAGCOORD.x> 600.0 || FRAGCOORD.x < 200.0) {
		ALPHA = 1.0;
	} else {
		float l = 0.004 * abs(400.0-FRAGCOORD.x);
		ALPHA = min(l*l,1.0);
	}
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	DIFFUSE_LIGHT = vec3(0.0,0.0,0.0);
}
