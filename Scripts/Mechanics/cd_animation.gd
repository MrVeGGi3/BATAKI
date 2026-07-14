extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	AudioManager.play_sfx(AudioManager.start_game_cd_sound)


## Chamado por um track de método da animação da contagem, no último frame.
func _change_game_screen():
	ScreenFlow.go_to(ScreenFlow.Screen.GAMEPLAY)
