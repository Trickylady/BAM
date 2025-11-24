extends Control

func _ready():
	Input.set_custom_mouse_cursor(preload("res://cursor.png"))
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
		%MenuBack.pressed.connect(_backtomenubutton)
		$Nextbutton.pressed.connect(_next_level)
		
func update_label_color(color: String, label: RichTextLabel, text: String) -> void:
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, text]

func _backtomenubutton() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _next_level() -> void:
	get_tree().change_scene_to_file("res://level2.tscn")
