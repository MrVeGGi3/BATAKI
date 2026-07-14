extends Node
@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var click_sound = preload("uid://bn4hsqjie0xa6")
var countdown_sound = preload("uid://dh6npdscrensw")
var win_sound = preload("uid://doa2dnpt8t5qy")
var wrong_button_sound = preload("uid://d0y3lapgbgexq")
var correct_button_sound = preload("uid://c6fwmx4uuo3j5")
var start_game_cd_sound = preload("uid://b7f1vgikppcql")


var combo_stream_2_sfx = preload("uid://dog0u41gcdtkk")
var combo_stream_3_sfx = preload("uid://2o6avp4scang")
var combo_stream_4_sfx = preload("uid://cfwx83tibdooe")
var combo_stream_5_sfx = preload("uid://cgbrirany2r8i")


var game_bgm = preload("uid://dyrwbwfo7kyhk")
var menu_bgm = preload("uid://bxo08t1aqywtl")

func _ready() -> void:
	add_child(music_player)
	music_player.bus = "Music" 

func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream and music_player.playing:
		return 
	
	music_player.stream = stream
	music_player.play()

func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
		
	var new_player = AudioStreamPlayer.new()
	new_player.stream = stream
	new_player.bus = "SFX"
	
	add_child(new_player)
	new_player.play()
	
	new_player.finished.connect(func(): new_player.queue_free())
