extends Button

## O caminho da próxima cena para onde este botão vai levar.
@export_file("*.tscn") var next_scene_path: String

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	InactivityManager.reset_timer()
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
