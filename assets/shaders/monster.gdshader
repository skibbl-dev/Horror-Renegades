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
	ALPHA = float( int( TIME * random(UV + vec2(TIME/16.0,TIME/16.0)) ) %int(6) ) * 0.03;
	ALBEDO.r  = float( int( TIME * random(UV + vec2(TIME/32.0,TIME/32.0)) ) %int(8) ) * 0.4;
	ALBEDO.g  = float( int( TIME * random(UV + vec2(TIME/48.0,TIME/48.0)) ) %int(8) ) * 0.4;
	ALBEDO.b  = float( int( TIME * random(UV + vec2(TIME/64.0,TIME/64.0)) ) %int(8) ) * 0.4;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
