class_name LabelsTextManager
extends Node

@export var points_label : Label
@export var timer_label : Label
@export var streak_combo_label : Label

@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"
@onready var bataki_timer: BatakiTimer = $"../BatakiTimer"

func _ready() -> void:
	score_counter_manager.points_uptaded.connect(_update_points_label)
	bataki_timer.update_time.connect(_update_timer_label)
	score_counter_manager.combo_updated.connect(_update_streak_combo_label)
	

func _update_points_label(points : int):
	points_label.text = str(points)
	
func _update_timer_label(time: int):
	timer_label.text = str(time)
	
func _update_streak_combo_label(combo : int):
	streak_combo_label.text = "X" + str(combo) + "!"
