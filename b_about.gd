extends Button

@onready var label = $TAbout

var base_text := "About"
var hover_color := "#6c098c"
var pressed_color := "#4b6d5f"

func _ready():
	update_label_color("white")

func _on_Button_pressed():
	update_label_color(pressed_color)

func update_label_color(color: String):
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, base_text]

func _on_button_up() -> void:
	update_label_color("white")

func _on_pressed() -> void:
	update_label_color(pressed_color)

func _on_mouse_entered() -> void:
	update_label_color(hover_color)

func _on_mouse_exited() -> void:
	update_label_color("white")
