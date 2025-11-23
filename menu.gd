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
	_backtomenu()
	%ButtonBack.hide()
	%ButtonNewGame.pressed.connect(_on_new_game)
	%ButtonAbout.pressed.connect(_about)
	%ButtonPreferences.pressed.connect(_preferences)
	%ButtonScore.pressed.connect(_scoreboard)
	%ButtonBack.pressed.connect(_backtomenu)
	%ButtonExit.pressed.connect(_exit)
	

func update_label_color(color: String, label: RichTextLabel, text: String) -> void:
	label.text = "[color=%s][wave amp=20 freq=7]%s[/wave][/color]" % [color, text]
	
	
func _on_new_game() -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
	Input.mouse_mode =Input.MOUSE_MODE_HIDDEN

func _backtomenu() -> void:
	%ButtonBack.hide()
	$Abouttab.hide()
	$Menulist.show()
	$Scoreboardtab.hide()
	$Preferencestab.hide()

func _about() -> void:
	%ButtonBack.show()
	$Abouttab.show()
	$Menulist.hide()
	$Scoreboardtab.hide()
	$Preferencestab.hide()

func _preferences() -> void:
	%ButtonBack.show()
	$Abouttab.hide()
	$Menulist.hide()
	$Scoreboardtab.hide()
	$Preferencestab.show()

func _scoreboard() -> void:
	%ButtonBack.show()
	$Abouttab.hide()
	$Menulist.hide()
	$Scoreboardtab.show()
	$Preferencestab.hide()

func _exit() -> void:
	get_tree().quit()
