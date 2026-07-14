extends Node

## Estado do jogador da partida atual. Não navega entre telas — isso é do ScreenFlow.

var pontuacao_atual: int = 0
var user_name : String
var user_email : String
var user_enterprise : String

var first_name : String
var actual_data_hour : String
var actual_hour : String

var current_run_id : int = -1
var max_sequence : int = 0
## Em segundos. 0.0 quando o jogador não acertou nada.
var average_reaction_time : float = 0.0


## Descarta os dados do jogador. Chamado pelo ScreenFlow ao voltar para o início.
func reset_run() -> void:
	current_run_id = -1
	pontuacao_atual = 0
	max_sequence = 0
	average_reaction_time = 0.0
	user_name = ""
	user_email = ""
	user_enterprise = ""
	first_name = ""
	actual_data_hour = ""
	actual_hour = ""


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

func salvar_dados_jogo(points : int, avg_t_react : float, max_seq : int):
	pontuacao_atual = points
	average_reaction_time = avg_t_react
	max_sequence = max_seq

func get_actual_data_and_hour():
	actual_data_hour = Time.get_datetime_string_from_system()
