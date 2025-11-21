extends Node2D

var buttons : Array[Button]
var hover_color := "#4b294b"
var pressed_color := "#4b6d5f"

func _ready():
	update_label_color("white")
	get_all_buttons()

func get_all_buttons():
	for child in get_children():
		if child is Button:
			buttons.append(child)

func update_label_color(color: String, label):
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, base_text]

func _on_pressed() -> void:
	update_label_color(pressed_color)

func _on_mouse_entered() -> void:
	update_label_color(hover_color)

func _on_mouse_exited() -> void:
	update_label_color("white")
