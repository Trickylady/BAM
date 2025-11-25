extends Control


func _ready() -> void:
	if Mng.is_publish: %ButtonTest.hide()
	if Mng.is_web: %ButtonExit.hide()
	Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
	for btn: Button in get_tree().get_nodes_in_group("buttons"):
		if not btn.get_child_count() == 1:
			continue
		if not btn.get_child(0) is RichTextLabel:
			continue
		var label: RichTextLabel = btn.get_child(0)
		btn.pressed.connect(update_label_color.bind("#4b6d5f", label, label.text))
		btn.mouse_entered.connect(update_label_color.bind("#4b294b", label, label.text))
		btn.mouse_exited.connect(update_label_color.bind("white", label, label.text))
	%TabContainer.current_tab = 0


func update_label_color(color: String, label: RichTextLabel, text: String) -> void:
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, text]



func _on_tab_container_tab_changed(tab: int) -> void:
	%ButtonBack.visible = tab != 0


func _on_button_test_pressed() -> void: Mng.start_test_game()
func _on_button_new_game_pressed() -> void: Mng.start_game()
func _on_button_back_pressed() -> void: %TabContainer.current_tab = 0
func _on_button_about_pressed() -> void: %TabContainer.current_tab = 1
func _on_button_preferences_pressed() -> void: %TabContainer.current_tab = 2
func _on_button_score_pressed() -> void: %TabContainer.current_tab = 3
func _on_button_exit_pressed() -> void: get_tree().quit()
