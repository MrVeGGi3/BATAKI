class_name BatakiSorter
extends Node

## Sorteia qual bataki acende. Fala em índices — não conhece botão, textura nem cena.

## Quantos batakis existem no grid (3x3).
@export var bataki_count: int = 9

signal bataki_sorted(index: int)

## Índice do bataki aceso agora. -1 = nenhum.
var active_index: int = -1


func sort_new_bataki() -> void:
	var candidates: Array[int] = []
	for i in bataki_count:
		if i != active_index:      # nunca sorteia o mesmo duas vezes seguidas
			candidates.append(i)

	active_index = candidates.pick_random()
	bataki_sorted.emit(active_index)


func is_active(index: int) -> bool:
	return index == active_index


func reset() -> void:
	active_index = -1
