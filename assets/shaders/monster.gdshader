shader_type spatial;
render_mode unshaded;

varying vec2 position;

void vertex() {
	position = VERTEX.xy;
	
}

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	ALPHA = float( int( (TIME+7.0) * random(UV + vec2(TIME/6.0,TIME/6.0)) ) %int(7) ) * 0.06;
	ALBEDO.r = float( int( (TIME+100.0) * random(UV)) % int(100) ) * 0.01;
	ALBEDO.g = float( int( (TIME+100.0) * random(UV)) % int(100) ) * 0.01;
	ALBEDO.b = float( int( (TIME+100.0) * random(UV)) % int(100) ) * 0.01;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
