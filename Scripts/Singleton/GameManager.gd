extends Node

## O caminho da cena inicial para onde o jogo deve retornar.
@export_file("*.tscn") var home_scene_path: String = "res://Scenes/MainInterface.tscn"

var pontuacao_atual: int = 0

func voltar_para_home() -> void:
	print("GameManager: Retornando para a home...")
	pontuacao_atual = 0 # Reseta o jogo
	
	var erro = get_tree().change_scene_to_file(home_scene_path)
	if erro != OK:
		push_error("Erro ao mudar de cena: ", erro)
