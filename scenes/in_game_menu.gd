extends Control



func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _on_continue_pressed() -> void:
	hide()


func _on_menu_back_pressed() -> void:
	Mng.go_to_main_menu()
