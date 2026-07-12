extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var gameplay_screen : Control

const TEXTURES = {
	1 : preload("uid://c6giid8n1qbh6"),
	2 : preload("uid://bffxcwvaxa4in"),
	3 : preload("uid://dqvdpodgifkfl"),
	4 : preload("uid://cj57r2rn05id3")
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InactivityManager.stop_timer()


func _activate_game_screen():
	gameplay_screen.show()
	#Disparar método que inicia todo o game loop
