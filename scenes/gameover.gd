extends Control


func _ready() -> void:
	for btn: Button in get_tree().get_nodes_in_group("buttons"):
		if not btn.get_child_count() == 1:
			continue
		if not btn.get_child(0) is RichTextLabel:
			continue
		var label: RichTextLabel = btn.get_child(0)
		btn.pressed.connect(update_label_color.bind("#4b6d5f", label, label.text))
		btn.mouse_entered.connect(update_label_color.bind("#4b294b", label, label.text))
		btn.mouse_exited.connect(update_label_color.bind("white", label, label.text))


func update_label_color(color: String, label: RichTextLabel, text: String) -> void:
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, text]


func update() -> void:
	%TextScore.text = "Score: %d" % (Mng.global_scores + Mng.current_scores)


func _on_menu_back_pressed() -> void:
	Mng.go_to_main_menu()


func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		update()
