extends CanvasLayer

@onready var sql_manipulator: SQLManipulator = $SQLManipulator
@onready var player_stats_block_ui_manager: Node = $PlayerStatsBlockUIManager
@onready var labels_text_updater: Node = $LabelsTextUpdater

func _ready() -> void:
	AudioManager.play_sfx(AudioManager.win_sound)
	labels_text_updater.update_labels()
	GameManager.get_actual_data_and_hour()
	# Sem o insert não há current_run_id: o refresh destacaria a linha de outro jogador.
	if not sql_manipulator.update_database():
		GameManager.current_run_id = -1
	player_stats_block_ui_manager.refresh()
	# O timer de inatividade desta tela já foi ligado pelo ScreenFlow.

func _on_play_again_texture_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.click_sound)
	ScreenFlow.go_to(ScreenFlow.Screen.COUNTDOWN)

func _on_go_home_texture_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.click_sound)
	ScreenFlow.go_home()
