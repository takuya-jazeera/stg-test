shader_type spatial;
// render_mode unshaded;

uniform sampler2D tex;		
uniform float flash = 0.0;	// taken damage

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	ALBEDO = texture(tex,UV).xyz + flash * vec3(1.0,1.0,1.0);
	
	// ALPHA = koma.z * texture(tex,UV*0.25 + 0.25 * koma.xy).w;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	DIFFUSE_LIGHT = flash * vec3(1.0,1.0,1.0);
}
