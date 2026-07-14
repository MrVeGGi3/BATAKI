extends Node

## Dono único da navegação entre telas.
##
## Nenhum outro script deve chamar change_scene_to_file(): todo caminho do jogo
## passa por go_to() ou go_home(). É o que garante que "Jogar de novo" e "Começar"
## levem exatamente à mesma tela.

enum Screen { HOME, COUNTDOWN, GAMEPLAY, LEADERBOARD }

const SCENES := {
	Screen.HOME:        "res://Scenes/MainInterface.tscn",
	Screen.COUNTDOWN:   "res://Scenes/CDInterface.tscn",
	Screen.GAMEPLAY:    "res://Scenes/GameplayInterface.tscn",
	Screen.LEADERBOARD: "res://Scenes/LeaderboardInterface.tscn",
}

## Em quais telas o timer de inatividade corre.
## HOME é o destino do idle, não a origem — ligá-lo lá faria a tela se recarregar sozinha.
## COUNTDOWN e GAMEPLAY são curtas e limitadas pelo próprio cronômetro da partida.
const RUNS_IDLE_TIMER := {
	Screen.HOME:        false,
	Screen.COUNTDOWN:   false,
	Screen.GAMEPLAY:    false,
	Screen.LEADERBOARD: true,
}

var current_screen: Screen = Screen.HOME


func go_to(screen: Screen) -> void:
	current_screen = screen

	if RUNS_IDLE_TIMER[screen]:
		InactivityManager.start_timer()
	else:
		InactivityManager.stop_timer()

	var erro := get_tree().change_scene_to_file(SCENES[screen])
	if erro != OK:
		push_error("Falha ao abrir a tela %s (%s): erro %s" % [
			Screen.keys()[screen], SCENES[screen], error_string(erro)])


## Volta ao início E descarta os dados do jogador atual.
## É o caminho de saída de qualquer estado — inatividade, botão de sair, fim de partida.
func go_home() -> void:
	GameManager.reset_run()
	go_to(Screen.HOME)
