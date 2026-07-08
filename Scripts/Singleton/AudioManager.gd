extends Node
@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(music_player)
	music_player.bus = "Music" 

## Função para tocar música de fundo (substitui a anterior suavemente)
func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream and music_player.playing:
		return 
	
	music_player.stream = stream
	music_player.play()

## Função mágica para SFX: Cria um player temporário que se destrói sozinho!
func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
		
	var new_player = AudioStreamPlayer.new()
	new_player.stream = stream
	new_player.bus = "SFX"
	
	add_child(new_player)
	new_player.play()
	
	new_player.finished.connect(func(): new_player.queue_free())
