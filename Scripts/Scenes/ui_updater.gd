extends CanvasLayer

@export var game_loop_scene = "res://Scenes/GameLoop.tscn"

@onready var main_screen_ui: Control = $MainScreenUI
@onready var form_screen_ui: FormScreenUI = $FormScreenUI
@onready var rules_screen_ui: Control = $RulesUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var forms_verifier: FormsVerifier = $FormsVerifier


func _ready() -> void:
	reset_totem_ui()

func reset_totem_ui() -> void:
	form_screen_ui.hide()
	rules_screen_ui.hide()
	main_screen_ui.show()
	form_screen_ui.clear_fields()

func _on_start_game_button_pressed() -> void:
	InactivityManager.start_timer()
	animation_player.play("form_screen_selected")

func _on_play_game_button_pressed() -> void:
	InactivityManager.reset_timer()
	
	var txt_name: String = form_screen_ui.name_edit.text
	var txt_email: String = form_screen_ui.email_edit.text
	var txt_enterprise: String = form_screen_ui.enterprise_edit.text

	if forms_verifier.is_form_valid(txt_name):
		forms_verifier.save_to_manager(txt_name, txt_email, txt_enterprise)
		animation_player.play("rules_screen_selected")

func _on_back_home_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_rules_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file(game_loop_scene)
