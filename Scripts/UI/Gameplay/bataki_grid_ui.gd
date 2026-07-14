class_name BatakiGridUI
extends Node

## A única camada que sabe que um bataki é um TextureButton.
##
## Para cima ela fala em índices (0..8): avisa qual foi tocado e recebe ordens de
## acender/piscar. A lógica de jogo do outro lado nunca vê um nó de interface.

@export var buttons: Array[TextureButton] = []
@export var button_effect_manager: ButtonEffectManager
@export var particle_effect_manager: ParticleEffectManager

signal bataki_pressed(index: int)


func _ready() -> void:
	for i in buttons.size():
		buttons[i].pressed.connect(_on_button_pressed.bind(i))


func _on_button_pressed(index: int) -> void:
	bataki_pressed.emit(index)


func light_up(index: int) -> void:
	button_effect_manager.turn_on_bataki(buttons[index])


func show_hit(index: int) -> void:
	button_effect_manager.correct_effect(buttons[index])
	particle_effect_manager.burst_hit(index, _center_of(buttons[index]))


func _center_of(button: TextureButton) -> Vector2:
	return button.get_global_rect().get_center()


func show_miss(index: int) -> void:
	button_effect_manager.error_effect(buttons[index])
