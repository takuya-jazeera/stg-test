shader_type spatial;
render_mode unshaded;

uniform sampler2D tex : repeat_enable;		
uniform vec2 phases = vec2(0.0);	// taken damage

void vertex() {
	VERTEX.x = VERTEX.x + 1.0 * sin(phases.x + 0.4 * VERTEX.y);
	VERTEX = (1.0 + 0.1 * cos(phases.x)) * VERTEX;
	// Called for every vertex the material is visible on.
}


void fragment() {
	ALBEDO = 0.5* texture(tex,UV* 4.0 + phases.y * vec2(0.0,1.0)).xyz;
	
	// ALPHA = koma.z * texture(tex,UV*0.25 + 0.25 * koma.xy).w;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	//DIFFUSE_LIGHT = flash * vec3(1.0,1.0,1.0);
}
