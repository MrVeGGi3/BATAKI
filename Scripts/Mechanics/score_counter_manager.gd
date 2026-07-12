class_name  ScoreCounterManager
extends Node

@onready var bataki_sorter: BatakiSorter = $"../BatakiSorter"
@onready var button_effect_manager: ButtonEffectManager = $"../ButtonEffectManager"

var actual_score : int

signal combo_updated (new_combo: int)
signal points_uptaded (points : int)

##Valor acrescentado por cada item
@export var score_to_add : int = 10

##Quantidade de Acertos seguidos para se considerar um aumento no streak
@export var seq_up_st_combo : int = 5
var sequence : int
var streak_combo : int = 1 

func check_correct_button(button : TextureButton):
	if bataki_sorter.get_bataki_status():
		add_score()
		button_effect_manager.correct_effect(button)
		bataki_sorter.sort_new_bataki()
	else:
		button_effect_manager.error_effect(button)
		sequence = 0
		streak_combo = 1
		
func add_score():
	sequence += 1
	define_streak_combo()
	
	var multiplicador = max(1, streak_combo)
	actual_score += score_to_add * multiplicador
	points_uptaded.emit(actual_score)

func define_streak_combo():
	var old_combo = streak_combo
	streak_combo = int(sequence / seq_up_st_combo) + 1
	
	if streak_combo > old_combo:
		combo_updated.emit(streak_combo)
	
func update_player_stats():
	GameManager.salvar_dados_jogo(actual_score)
	
