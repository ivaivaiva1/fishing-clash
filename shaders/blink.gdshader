shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_pct : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	tex *= COLOR;
	
	tex.rgb = mix(tex.rgb, flash_color.rgb * tex.a, flash_pct);
	
	COLOR = tex;
}