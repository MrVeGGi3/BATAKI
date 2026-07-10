extends Control

@onready var bataki_sorter: BatakiSorter = $BatakiSorter
@onready var bataki_timer: BatakiTimer = $BatakiTimer


func _on_exit_label_pressed() -> void:
	GameManager.return_to_home()


func start_game():
	bataki_timer.start_counter()
	bataki_sorter.sort_new_bataki()
