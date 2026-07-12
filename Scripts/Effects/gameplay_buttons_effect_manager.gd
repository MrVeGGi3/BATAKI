class_name ButtonEffectManager
extends Node

enum Estado { NORMAL = 0, TURN_ON = 1, ERROR = 2, CORRECT = 3 }

const TEXTURAS = {
	Estado.NORMAL: preload("uid://basdy54lbn6op"),
	Estado.TURN_ON: preload("uid://d3rnmy060oyye"),
	Estado.ERROR: preload("uid://banhs1bvs480t"),
	Estado.CORRECT: preload("uid://cuqjua1rxql68")
}

func _mudar_estado_botao(botao: TextureButton, estado: Estado):
	if TEXTURAS.has(estado):
		botao.texture_normal = TEXTURAS[estado]


func turn_on_bataki(texture_r : TextureButton):
	print("Estou alterando a textura do Bataki para o estado de sinalização")
	_mudar_estado_botao(texture_r, Estado.TURN_ON)
	
func turn_off_bataki(texture_r :TextureButton):
	_mudar_estado_botao(texture_r, Estado.NORMAL)


func correct_effect(texture_r : TextureButton):
	_mudar_estado_botao(texture_r, Estado.CORRECT)
	
	texture_r.pivot_offset = texture_r.size / 2
	
	var tween = create_tween().set_parallel(false)
	tween.tween_property(texture_r, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(texture_r, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_callback(func(): _mudar_estado_botao(texture_r, Estado.NORMAL))


func error_effect(texture_r : TextureButton):
	_mudar_estado_botao(texture_r, Estado.ERROR)
	
	var tween = create_tween().set_parallel(false)
	tween.tween_property(texture_r, "modulate", Color(1, 0.4, 0.4, 1), 0.1)
	tween.tween_property(texture_r, "modulate", Color(1, 1, 1, 1), 0.1)
	tween.tween_property(texture_r, "modulate", Color(1, 0.4, 0.4, 1), 0.1)
	tween.tween_property(texture_r, "modulate", Color(1, 1, 1, 1), 0.1)
	
	tween.tween_callback(func(): _mudar_estado_botao(texture_r, Estado.NORMAL))
