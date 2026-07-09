class_name FormsVerifier
extends Node


func is_form_valid(user_name: String) -> bool:
	return user_name.strip_edges() != ""

func save_to_manager(user_name: String, user_email: String, user_enterprise: String) -> void:
	GameManager.save_user_data(
		user_name.strip_edges(), 
		user_email.strip_edges(), 
		user_enterprise.strip_edges()
	)
