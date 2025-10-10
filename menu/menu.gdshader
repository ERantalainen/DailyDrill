shader_type canvas_item;
uniform float greyscale_amount : hint_range(0.0, 0.9) = 0.9;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float grey = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(color.rgb, vec3(grey), greyscale_amount);
    COLOR = color;
}


void vertex() {
	// Called for every vertex the material is visible on.
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
