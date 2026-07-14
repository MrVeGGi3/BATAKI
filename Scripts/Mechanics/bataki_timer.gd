class_name BatakiTimer
extends Node

## Cronômetro da partida. Não conhece textura, cena nem singleton — só emite o que acontece.

##Tempo total para o jogador
@export var initial_max_time : float = 30.0
##Quanto tempo restante já conta como "acabando"
@export var warn_time : float = 5.0

## Entrou (ou saiu) da reta final. Emitido uma vez na virada, não a cada frame.
signal time_warn(is_warning : bool)
signal update_time(time : int)
## O tempo acabou. Quem decide o que fazer com isso é a tela, não o cronômetro.
signal game_over
## Quanto o jogador demorou para acertar o bataki que estava aceso.
signal reaction_measured(time : float)


var actual_time : float
var can_run : bool = false

var _is_warning : bool = false

## Cronômetro da reação em curso. Só corre durante a partida: fora dela não há
## bataki aceso, e o tempo parado na tela não é reação de ninguém.
var _reaction_elapsed : float = 0.0


func _ready() -> void:
	actual_time = initial_max_time


func _process(delta: float) -> void:
	if not can_run:
		return

	_reaction_elapsed += delta
	_run_game_timer(delta)

func _run_game_timer(delta : float):
	actual_time -= delta

	if actual_time <= 0.0:
		game_timeout()
		return

	if not _is_warning and actual_time <= warn_time:
		_is_warning = true
		time_warn.emit(true)

	update_time.emit(actual_time)

## Fecha a medição da reação atual e já começa a próxima.
## Quem chama é a tela, a cada acerto — o cronômetro não sabe o que é um acerto.
func mark_reaction() -> void:
	reaction_measured.emit(_reaction_elapsed)
	_reaction_elapsed = 0.0


func start_counter() -> void:
	actual_time = initial_max_time
	_reaction_elapsed = 0.0
	_is_warning = false
	can_run = true


func game_timeout() -> void:
	_reset_timer()
	game_over.emit()


func _reset_timer() -> void:
	can_run = false
	actual_time = 0.0
	_is_warning = false
	time_warn.emit(false)
	
