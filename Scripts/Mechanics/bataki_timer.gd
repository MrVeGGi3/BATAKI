extends Node

@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"

@export var initial_max_time : float = 30.0
var actual_time : float
var can_run : bool = false

func _ready() -> void:
	actual_time = initial_max_time
	
func _process(delta: float) -> void:
	if can_run:
		actual_time -= delta
		if actual_time <= 0.0:
			game_timeout()

func game_timeout():
	can_run = false
	score_counter_manager.update_player_stats()
	
	
		
		
