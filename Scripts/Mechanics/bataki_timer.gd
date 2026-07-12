class_name BatakiTimer
extends Node

@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"
@onready var textures_effect_manager: TexturesEffectManager = $"../TexturesEffectManager"

signal time_warn(state : TexturesEffectManager.TimeTextureState)
signal update_time(time : int)


##Tempo total para o jogador
@export var initial_max_time : float = 30.0
##Tempo que o background do timer muda quando está acabando
@export var warn_time : float = 5.0
var actual_time : float
var can_run : bool = false

func _ready() -> void:
	actual_time = initial_max_time
	
func _process(delta: float) -> void:
	if can_run:
		actual_time -= delta
		if actual_time <= 0.0:
			game_timeout()
		elif actual_time <= 5.0:
			time_warn.emit(TexturesEffectManager.TimeTextureState.WARN)
		update_time.emit(actual_time)

func game_timeout():
	_reset_timer()
	score_counter_manager.update_player_stats()
	#TODO: get_tree().change_scene_to_file(cena_do leaderboard)
	
func start_counter():
	print("Iniciando Timer")
	can_run = true
		
func _reset_timer():
	can_run = false
	actual_time = 0.0
	time_warn.emit(TexturesEffectManager.TimeTextureState.NORMAL)
