shader_type canvas_item;

// Suas 3 cores exatas (Hex convertidos para RGBA)
uniform vec4 color1 : source_color = vec4(0.874, 1.0, 0.784, 1.0);  
uniform vec4 color2 : source_color = vec4(0.423, 0.898, 0.145, 1.0); 
uniform vec4 color3 : source_color = vec4(0.239, 0.533, 0.0, 1.0);   

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius1 = 0.0;
uniform float radius2 = 0.3;
uniform float radius3 = 0.6;

void fragment() {
	// 1. Pega a amostragem original do texto (essencial para fontes)
	vec4 text_sample = texture(TEXTURE, UV);
	
	// 2. Calcula a distância a partir do centro corrigindo a proporção do nó
	vec2 st = UV - center;
	st.x *= TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x; 
	float d = length(st);

	// 3. Calcula as transições do gradiente de 3 cores
	float t1 = smoothstep(radius1, radius2, d);
	vec4 gradient_mix1 = mix(color1, color2, t1);
	
	float t2 = smoothstep(radius2, radius3, d);
	vec4 final_gradient = mix(gradient_mix1, color3, t2);

	// 4. Aplica o gradiente no RGB, mas MULTIPLICA pelo Alpha (text_sample.a) do texto original
	COLOR = vec4(final_gradient.rgb, text_sample.a * final_gradient.a);
}