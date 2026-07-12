extends Control
class_name FormScreenUIManager

@onready var name_edit: LineEdit = $MainContainer/FillNameContainer/UserNameLineEdit
@onready var email_edit: LineEdit = $MainContainer/FillEmailContainer/UserEmailLineEdit
@onready var enterprise_edit: LineEdit = $MainContainer/FillEnterpriseContainer/UserEnterpriseLineEdit

@onready var forms_verifier: FormsManager = $"../FormsManager"
@onready var play_game_button: TextureButton = $MainContainer/ContinueTextureButton


func _ready() -> void:
	play_game_button.disabled = true
	name_edit.text_changed.connect(_on_input_activity)
	email_edit.text_changed.connect(_on_input_activity)
	enterprise_edit.text_changed.connect(_on_input_activity)

func _update_button_state()-> void:
	var valid_form : bool = forms_verifier.is_form_valid(name_edit.text)
	play_game_button.disabled = not valid_form

func _on_input_activity(_new_text: String) -> void:
	InactivityManager.reset_timer()
	_update_button_state()

func clear_fields() -> void:
	name_edit.clear()
	email_edit.clear()
	enterprise_edit.clear()
