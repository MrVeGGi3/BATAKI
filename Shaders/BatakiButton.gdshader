shader_type canvas_item;

// Suas 3 cores exatas (Hex convertidos para RGBA)
uniform vec4 color1 : source_color = vec4(0.874, 1.0, 0.784, 1.0);  
uniform vec4 color2 : source_color = vec4(0.423, 0.898, 0.145, 1.0); 
uniform vec4 color3 : source_color = vec4(0.239, 0.533, 0.0, 1.0);   
uniform vec4 color_inactive : source_color = vec4(0.078, 0.078, 0.078, 1.0); 

uniform float activation_blend : hint_range(0.0, 1.0) = 0.0;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius1 = 0.0;
uniform float radius2 = 0.3;
uniform float radius3 = 0.6;

void fragment() {
    vec2 st = UV - center;
    st.x *= TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x; 
    float d = length(st);

    float t1 = smoothstep(radius1, radius2, d);
    vec4 gradient_mix1 = mix(color1, color2, t1);
    
    float t2 = smoothstep(radius2, radius3, d);
    vec4 final_gradient = mix(gradient_mix1, color3, t2);

    COLOR = mix(color_inactive, final_gradient, activation_blend);
}