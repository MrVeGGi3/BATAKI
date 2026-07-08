shader_type canvas_item;

uniform vec4 cor_base : source_color = vec4(0.424, 0.898, 0.145, 1.0);

uniform float opacidade_centro : hint_range(0.0, 1.0) = 0.16;

uniform float raio_maximo : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    float distancia = distance(UV, vec2(0.5, 0.5));
    
    float fator_brilho = smoothstep(raio_maximo, 0.0, distancia);
    
    vec4 cor_final = cor_base;
    cor_final.a = fator_brilho * opacidade_centro;
    
    COLOR = cor_final;
}