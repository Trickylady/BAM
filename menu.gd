extends Control


# buttons colors
var hover_color := "#4b294b"
var pressed_color := "#4b6d5f"


func _ready():
	for btn: Button in get_tree().get_nodes_in_group("buttons"):
		if not btn.get_child_count() == 1:
			continue
		if not btn.get_child(0) is RichTextLabel:
			continue
		
		var label: RichTextLabel = btn.get_child(0)
		btn.pressed.connect( update_label_color.bind(pressed_color, label, label.text) )
		btn.mouse_entered.connect( update_label_color.bind(hover_color, label, label.text) )
		btn.mouse_exited.connect( update_label_color.bind("white", label, label.text) )


func update_label_color(color: String, label: RichTextLabel, text: String) -> void:
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, text]
