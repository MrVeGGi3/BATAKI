shader_type canvas_item;

uniform vec4 cor_inicio : source_color = vec4(0.572, 0.988, 0.337, 1.0); // Verde #93FC56 padrão
uniform vec4 cor_fim : source_color = vec4(0.0, 0.0, 0.0, 1.0);          // Preto padrão

uniform bool horizontal = false;

void fragment() {
    float fator_alinhamento = horizontal ? UV.x : UV.y;
    
    COLOR = mix(cor_inicio, cor_fim, fator_alinhamento);
}
