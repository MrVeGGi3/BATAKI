class_name BatakiSorter
extends Node

@export var bataki_buttons : Array[TextureButton]

@export var score_counter_manager : ScoreCounterManager
@onready var button_effect_manager: ButtonEffectManager = $"../ButtonEffectManager"


var actual_sort_bataki : TextureButton = null


func _ready() -> void:
	assign_signal_activation()

func assign_signal_activation():
	for bataki in bataki_buttons:
		bataki.pressed.connect(score_counter_manager.check_correct_button.bind(bataki))


func sort_new_bataki():
	print("Sorteando novo Bataki")
	var valid_buttons = bataki_buttons.filter(
		func(button): return button != actual_sort_bataki)
	if valid_buttons.is_empty(): 
		valid_buttons = bataki_buttons
	var chosen_bataki = valid_buttons.pick_random()
	actual_sort_bataki = chosen_bataki
	button_effect_manager.turn_on_bataki(actual_sort_bataki)
	
func get_button_status(button : TextureButton):
	if button != actual_sort_bataki:
		return true
	else:
		return false
	
	
