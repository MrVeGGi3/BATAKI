shader_type canvas_item;

uniform vec4 cor_reflexo : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float opacidade_topo : hint_range(0.0, 1.0) = 0.024;

uniform float inicio_decaimento : hint_range(0.0, 1.0) = 0.2;

uniform float fim_decaimento : hint_range(0.0, 1.0) = 0.6;

void fragment() {
    float altura = UV.y;

    float fator_alfa = smoothstep(fim_decaimento, inicio_decaimento, altura);
    
    vec4 cor_final = cor_reflexo;
    cor_final.a = fator_alfa * opacidade_topo;
    
    COLOR = cor_final;
}
