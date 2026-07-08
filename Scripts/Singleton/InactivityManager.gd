extends Node

##Valor limite de Tempo para voltar na Tela Inicial
@export var max_counter_time: float = 10.0

var actual_timer_counter: float = 0.0
var can_run_timer: bool = true

func _process(delta: float) -> void:
	if can_run_timer and actual_timer_counter <= max_counter_time:
		actual_timer_counter += delta
		if actual_timer_counter >= max_counter_time:
			on_time_expired()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		reset_timer()

func on_time_expired() -> void:
	stop_timer()
	print("Tempo esgotado por inatividade!")
	GameManager.voltar_para_home()

func reset_timer() -> void:
	actual_timer_counter = 0.0

func start_timer() -> void:
	can_run_timer = true
	actual_timer_counter = 0.0

func stop_timer() -> void:
	can_run_timer = false
	actual_timer_counter = 0.0
