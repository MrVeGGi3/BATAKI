extends Node

## O caminho da cena inicial para onde o jogo deve retornar.
@export_file("*.tscn") var home_scene_path: String = "res://Scenes/MainInterface.tscn"

var pontuacao_atual: int = 0
var user_name : String
var user_email : String
var user_enterprise : String

var first_name : String
var actual_data_hour : String
var actual_hour : String

func return_to_home() -> void:
	print("GameManager: Retornando para a home...")
	pontuacao_atual = 0 
	user_name = ""
	user_email = ""
	user_enterprise = ""
	first_name = ""
	actual_data_hour = ""
	
	var erro = get_tree().change_scene_to_file(home_scene_path)
	if erro != OK:
		push_error("Erro ao mudar de cena: ", erro)
		
func save_user_data(p_name: String, p_email: String, p_enterprise: String) -> void:
	user_name = p_name
	user_email = p_email
	user_enterprise = p_enterprise
	_set_user_first_name()
	
	
func _set_user_first_name():
	if user_name != null and user_name != "":
		var parts = user_name.split(" ")
		first_name = parts[0]
	else:
		push_error("Nome de usuário não existente ou vazio")

func salvar_dados_jogo(points : int):
	pontuacao_atual = points


func get_actual_data_and_hour():
	actual_data_hour = Time.get_datetime_string_from_system()
