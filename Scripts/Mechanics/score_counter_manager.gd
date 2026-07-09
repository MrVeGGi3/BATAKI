class_name  ScoreCounterManager
extends Node

@onready var bataki_sorter: BatakiSorter = $"../BatakiSorter"
@onready var button_effect_manager: ButtonEffectManager = $"../ButtonEffectManager"

var actual_score : int

signal combo_updated (new_combo: int)


##Valor acrescentado por cada item
@export var add_score : int
@export var seq_up_st_combo : int = 5
var sequence : int
var streak_combo : int

func check_correct_button(button : BatakiButton):
	if button.is_chosen_bataki:
		button_effect_manager.erase_bataki(button)
		bataki_sorter.sort_new_bataki()
		
func adding_score():
	sequence += 1
	define_streak_combo()
	
	var multiplicador = max(1, streak_combo)
	actual_score += add_score * multiplicador

func define_streak_combo():
	var old_combo = streak_combo
	streak_combo = int(sequence / seq_up_st_combo) + 1
	
	if streak_combo > old_combo:
		combo_updated.emit(streak_combo)
	
func update_player_stats():
	GameManager.salvar_dados_jogo(actual_score)
