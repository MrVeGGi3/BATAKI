extends Control

@onready var bataki_sorter: BatakiSorter = $BatakiSorter
@onready var bataki_timer: BatakiTimer = $BatakiTimer
@onready var score_counter_manager: ScoreCounterManager = $ScoreCounterManager

func _ready() -> void:
	start_game() 

func _on_exit_label_pressed() -> void:
	GameManager.return_to_home()

func start_game():
	print("Jogo Iniciado")
	bataki_timer.start_counter()
	bataki_sorter.sort_new_bataki()
