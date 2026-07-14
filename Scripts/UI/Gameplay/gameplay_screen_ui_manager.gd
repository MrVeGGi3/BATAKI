extends Control

## Liga a lógica de jogo à interface. É o único script que conhece os dois lados:
## a lógica emite (sorteou o 4, acertou o 4, o tempo acabou) e a UI reage.

@onready var bataki_sorter: BatakiSorter = $BatakiSorter
@onready var bataki_timer: BatakiTimer = $BatakiTimer
@onready var score_counter_manager: ScoreCounterManager = $ScoreCounterManager
@onready var bataki_grid_ui: BatakiGridUI = $BatakiGridUI


func _ready() -> void:
	bataki_grid_ui.bataki_pressed.connect(score_counter_manager.on_bataki_pressed)
	bataki_sorter.bataki_sorted.connect(bataki_grid_ui.light_up)
	score_counter_manager.reaction_completed.connect(bataki_timer.mark_reaction) #Fecha a medida...
	bataki_timer.reaction_measured.connect(score_counter_manager._register_reaction_time) #...e a guarda
	score_counter_manager.hit.connect(bataki_grid_ui.show_hit) #Acerto do Player
	score_counter_manager.miss.connect(bataki_grid_ui.show_miss) #Erro do PLayer
	bataki_timer.game_over.connect(_on_game_over) #Término do Loop

	start_game()


func start_game() -> void:
	bataki_timer.start_counter()
	bataki_sorter.sort_new_bataki()


func _on_game_over() -> void:
	GameManager.salvar_dados_jogo(
		score_counter_manager.actual_score,
		score_counter_manager.get_average_reaction_time(),
		score_counter_manager.max_sequence_combo)
	ScreenFlow.go_to(ScreenFlow.Screen.LEADERBOARD)


func _on_exit_label_pressed() -> void:
	ScreenFlow.go_home()
