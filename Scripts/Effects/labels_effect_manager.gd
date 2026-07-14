class_name LabelsTextManager
extends Node

@export var points_label : Label
@export var timer_label : Label
@export var streak_combo_label : Label
@export var multiplier_label : Label
@export var sequence_label : Label
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"
@onready var bataki_timer: BatakiTimer = $"../BatakiTimer"

func _ready() -> void:
	score_counter_manager.points_updated.connect(_update_points_label)
	bataki_timer.update_time.connect(_update_timer_label)
	score_counter_manager.combo_updated.connect(_update_streak_combo_label)
	score_counter_manager.mult_updated.connect(_update_multiplier_label)
	score_counter_manager.seq_updated.connect(_update_sequence_label)

func _update_points_label(points : int):
	points_label.text = str(points)
	
func _update_timer_label(time: int):
	timer_label.text = str(time) +"s"
	
func _update_streak_combo_label(combo : int):
	animation_player.play("combo_update_anim")
	streak_combo_label.text = "X" + str(combo) + "!"
	
func _update_multiplier_label(mult : int):
	multiplier_label.text = "x" + str(mult)

func _update_sequence_label(seq : int):
	sequence_label.text = str(seq)
