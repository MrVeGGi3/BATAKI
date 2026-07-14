class_name ScoreCounterManager
extends Node

## Regras de pontuação. Não conhece botão, textura nem cena — só índices e números.
##
## A cada [member hits_for_combo] acertos seguidos o multiplicador sobe um degrau
## (até [member max_multiplier]) e uma janela de [member combo_duration] segundos é aberta.
## A janela expirar OU errar um bataki derruba o multiplicador de volta a x1 —
## é o que faz dele um bônus TEMPORÁRIO, e não uma escada que só sobe.

@export var bataki_sorter: BatakiSorter

## Pontos por acerto, antes do multiplicador.
@export var score_to_add : int = 10
## Acertos seguidos para subir um degrau no multiplicador.
@export var hits_for_combo : int = 5
## Teto do multiplicador. Sem ele, uma partida perfeita valeria mais que todas as outras somadas.
@export var max_multiplier : int = 5
## Quanto tempo o multiplicador sobrevive sem um novo degrau.
@export var combo_duration : float = 3.0


signal points_updated(points : int)
signal seq_updated(seq : int)
signal mult_updated(mult : int)
## Subiu (ou renovou) um degrau de combo — é o gancho do aviso "COMBO x2!".
signal combo_updated(new_combo : int)
## Acertou / errou o bataki de índice N. Quem pinta a tela reage a isto.
signal hit(index : int)
signal miss(index : int)
## Fecha a medição da reação em curso: o jogador enfim achou o bataki certo.
## Quem cronometra é o BatakiTimer — aqui só se avisa que a medida terminou.
signal reaction_completed

var actual_score : int = 0
## Acertos consecutivos. Só um erro zera isto.
var sequence : int = 0
## Nunca é 0: sem combo ativo, vale 1.
var multiplier : int = 1

## A maior [member sequence] que a partida chegou a ter. Diferente de [member sequence],
## sobrevive ao erro que zera a atual — é o que vai para o placar no fim.
var max_sequence_combo : int = 0

var _time_reaction : Array[float] = []

var _combo_time_left : float = 0.0

func _process(delta : float) -> void:
	if _combo_time_left <= 0.0:
		return

	_combo_time_left -= delta
	if _combo_time_left <= 0.0:
		_expire_combo()


func on_bataki_pressed(index : int) -> void:
	if bataki_sorter.is_active(index):
		reaction_completed.emit()
		_register_hit()
		hit.emit(index)
		bataki_sorter.sort_new_bataki()
	else:
		miss.emit(index)
		_break_combo()


func _register_reaction_time(r_time : float):
	_time_reaction.append(r_time)

func _register_hit() -> void:
	sequence += 1
	max_sequence_combo = maxi(sequence, max_sequence_combo)

	if sequence % hits_for_combo == 0:
		_advance_combo()

	actual_score += score_to_add * multiplier

	points_updated.emit(actual_score)
	seq_updated.emit(sequence)


## Sobe um degrau e reabre a janela. No teto, só reabre a janela.
func _advance_combo() -> void:
	_combo_time_left = combo_duration
	_set_multiplier(mini(multiplier + 1, max_multiplier))
	combo_updated.emit(multiplier)


## O jogador demorou demais: perde o bônus, mas a sequência de acertos continua de pé.
func _expire_combo() -> void:
	_combo_time_left = 0.0
	_set_multiplier(1)


## Errou: perde o bônus e a sequência.
func _break_combo() -> void:
	_combo_time_left = 0.0
	sequence = 0
	_set_multiplier(1)
	seq_updated.emit(sequence)


func _set_multiplier(value : int) -> void:
	if value == multiplier:
		return
	multiplier = value
	mult_updated.emit(multiplier)

## Segundos médios entre o bataki acender e o jogador acertá-lo.
## 0.0 quando não houve nenhum acerto — não existe reação para medir.
func get_average_reaction_time() -> float:
	if _time_reaction.is_empty():
		return 0.0

	var total : float = 0.0
	for reaction in _time_reaction:
		total += reaction
	return total / _time_reaction.size()
