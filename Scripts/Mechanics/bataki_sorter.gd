class_name BatakiSorter
extends Node

@export var bataki_buttons : Array[Button]
@export var score_counter_manager : ScoreCounterManager
@onready var button_effect_manager: ButtonEffectManager = $"../ButtonEffectManager"


var actual_sort_bataki : BatakiButton = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_signal_activation()

func assign_signal_activation():
	for bataki in bataki_buttons:
		bataki.pressed.connect(score_counter_manager.check_correct_button.bind(bataki))


func sort_new_bataki():
	var valid_buttons = bataki_buttons.filter(
		func(button): return button != actual_sort_bataki)
	if valid_buttons.is_empty(): 
		valid_buttons = bataki_buttons
	var chosen_bataki : BatakiButton = valid_buttons.pick_random()
	chosen_bataki.is_chosen_bataki = true
	actual_sort_bataki = chosen_bataki
	button_effect_manager.turn_on_bataki(actual_sort_bataki)
	
