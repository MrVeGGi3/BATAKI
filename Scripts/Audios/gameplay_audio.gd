extends Node

@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"
@onready var bataki_timer: BatakiTimer = $"../BatakiTimer"

func _ready() -> void:
	AudioManager.play_music(AudioManager.game_bgm)
	score_counter_manager.combo_updated.connect(_play_combo_audio)
	score_counter_manager.hit.connect(_play_correct_button_audio)
	score_counter_manager.miss.connect(_play_wrong_button_audio)
	bataki_timer.time_warn.connect(_play_countdown_audio)

func _play_combo_audio(combo : int):
	match combo:
		2:
			AudioManager.play_sfx(AudioManager.combo_stream_2_sfx)
		3:
			AudioManager.play_sfx(AudioManager.combo_stream_3_sfx)
		4:
			AudioManager.play_sfx(AudioManager.combo_stream_4_sfx)
		5:
			AudioManager.play_sfx(AudioManager.combo_stream_5_sfx)
		_:
			return
			
## O índice do bataki não importa para o som — mas precisa ser recebido,
## senão o Godot aborta a chamada por aridade.
func _play_correct_button_audio(_index : int):
	AudioManager.play_sfx(AudioManager.correct_button_sound)

func _play_wrong_button_audio(_index : int):
	AudioManager.play_sfx(AudioManager.wrong_button_sound)

## time_warn também é emitido com "false" no fim da partida, ao resetar o cronômetro.
func _play_countdown_audio(is_warning : bool):
	if not is_warning:
		return
	AudioManager.play_sfx(AudioManager.countdown_sound)
