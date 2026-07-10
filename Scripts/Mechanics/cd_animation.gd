extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var gameplay_screen : Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InactivityManager.stop_timer()


func _activate_game_screen():
	gameplay_screen.show()
	#Disparar método que inicia todo o game loop
