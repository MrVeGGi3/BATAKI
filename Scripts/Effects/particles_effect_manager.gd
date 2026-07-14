class_name ParticleEffectManager
extends Node


@export var hit_emitters: Array[CPUParticles2D] = []

## Burst de tela quando o multiplicador sobe. Fica atrás do texto do COMBO (z_index).
@export var combo_emitter: CPUParticles2D

@onready var score_counter_manager: ScoreCounterManager = $"../ScoreCounterManager"


func _ready() -> void:
	score_counter_manager.combo_updated.connect(_on_combo_updated)


func burst_hit(index: int, at: Vector2) -> void:
	if index < 0 or index >= hit_emitters.size():
		push_error("Sem emissor de partícula para o bataki %d" % index)
		return

	var emitter := hit_emitters[index]
	emitter.global_position = at
	emitter.restart()


func _on_combo_updated(_new_combo: int) -> void:
	combo_emitter.restart()
