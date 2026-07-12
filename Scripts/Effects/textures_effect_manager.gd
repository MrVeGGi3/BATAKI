class_name TexturesEffectManager
extends Node

@onready var bataki_timer: BatakiTimer = $"../BatakiTimer"

@export var timer_background : TextureRect
enum TimeTextureState {NORMAL = 0, WARN = 1}

func _ready() -> void:
	bataki_timer.time_warn.connect(_change_timer_background)

const TEXTURAS = {
	TimeTextureState.NORMAL:preload("uid://co6ykdntkc8kw"),
	TimeTextureState.WARN: preload("uid://c5qjhf5ekg87q")
}

func _change_timer_background(estado : TimeTextureState):
	timer_background.texture = TEXTURAS[estado]
