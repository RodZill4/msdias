shader_type spatial;
render_mode unshaded, cull_front;

void vertex() {
	VERTEX=VERTEX+0.01*NORMAL;
}

void fragment() {
	ALBEDO=vec3(1.0, 1.0, 1.0);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
