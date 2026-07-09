class_name ButtonEffectManager
extends Node

func turn_on_bataki(botao: Button) -> void:
	var mat = botao.material as ShaderMaterial
	if not mat: return
	botao.disabled = false
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/activation_blend", 1.0, 0.15)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func erase_bataki(botao: Button) -> void:
	var mat = botao.material as ShaderMaterial
	if not mat: return
	botao.disabled = true
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/activation_blend", 0.0, 0.15)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
		
