shader_type spatial;
uniform sampler2D tex;
uniform vec3 koma = vec3(0.0,0.0,0.0);

// よくここまでこれましたね
// みてくれてありがとう
// 以下のプログラムの説明を今書いているから
// ちょっとまってね

// 　どうやって説明しよう　難しい
//        U                      
//         ─────────────────►    
//     0.0                    1.0
//  0.0  ┌────┬────┬────┬────┐   
//V  │   │ AA │ BB │ CC │ DD │   
//   │   │ AA │ BB │ CC │ DD │   
//   │   ├────┼────┼────┼────┤   
//   │   │ EE │ FF │ GG │ HH │   
//   │   │ EE │ FF │ GG │ HH │   
//   │   ├────┼────┼────┼────┤   
//   │   │    │    │    │    │   
//   │   │    │    │    │    │   
//   │   ├────┼────┼────┼────┤   
//   │   │    │    │    │    │   
//   ▼   │    │    │    │    │   
//  1.0  └────┴────┴────┴────┘   

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
	ALBEDO = texture(tex,UV*0.25 + 0.25 * koma.xy).xyz;
	ALPHA = koma.z * texture(tex,UV*0.25 + 0.25 * koma.xy).w;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	DIFFUSE_LIGHT = vec3(1.0,1.0,1.0);
}
