extends TextureRect
class_name GameOverlay




func _ready() -> void:
	Mng.level_ready.connect(_on_level_ready)
	%winscreen.hide()
	%Gameover.hide()
	%InGameMenu.hide()


func _input(event: InputEvent) -> void:
	if %winscreen.visible: return
	if %Gameover.visible: return
	if event.is_action_pressed(&"ui_cancel"):
		toggle_menu()


func update_all() -> void:
	update_scores()
	update_lives()
	update_health()
	update_bombs()
	update_crystals()
	%LabelLevel.text = "Level %d/%d" % [Mng.current_level_num, Mng.levels_tot]


func toggle_menu() -> void:
	%InGameMenu.visible = !%InGameMenu.visible


func go_to_next_level_screen() -> void:
	%next_level_screen.show()
	pause_game_arena(true)


func go_to_win_screen() -> void:
	%winscreen.show()
	pause_game_arena(true)


func go_to_game_over() -> void:
	%Gameover.show()
	pause_game_arena(true)


func pause_game_arena(paused: bool) -> void:
	if not Mng.level:
		return
	var mode = Node.PROCESS_MODE_DISABLED if paused else Node.PROCESS_MODE_INHERIT
	Mng.level.arena.set_deferred("process_mode", mode)


func update_lives() -> void:
	%LabelLives.text = "x%d" % Mng.dragon_lives
func update_crystals() -> void:
	%LabelCrystals.text = "%d/%d" % [Mng.level.crystals_collected, Mng.level.crystals_total]


func update_health() -> void:
	var ratio: float = Mng.dragon_health / Mng.PLAYER_MAX_HEALTH
	var tot_hearts: int = %GridHealth.get_child_count()
	for i: int in tot_hearts:
		var idx: int = i + 1
		var tex_rect: TextureRect = %GridHealth.get_child(i)
		
		var is_full: bool = idx <= int(ratio * tot_hearts)
		if is_full:
			tex_rect.texture = preload("res://theme/life_full.png")
			continue
		
		var is_half_full: bool = (idx*2 - 1) <= int(ratio * tot_hearts * 2)
		if is_half_full:
			tex_rect.texture = preload("res://theme/life_half.png")
			continue
		
		# is empty
		tex_rect.texture = preload("res://theme/life_empty.png")


func update_bombs() ->  void:
	var tot: int = Mng.level.player.max_bombs_at_once
	var placed: int = Mng.level.player.bombs_placed
	%LabelBombs.text = "%d/%d" % [placed, tot]
	%LabelBombPower.text = "%d tile(s)" % Mng.level.player.explosion_size


func update_scores() -> void:
	%LabelScores.text = "%05d" % (Mng.global_scores + Mng.current_scores)


func _on_level_ready() -> void:
	Mng.scores_updated.connect(_on_scores_updated)
	Mng.health_updated.connect(update_health)
	Mng.lives_updated.connect(update_lives)
	Mng.level.crystals_collected_updated.connect(update_crystals)
	Mng.level.player.bombs_updated.connect(update_bombs)
	
	update_all()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _on_scores_updated() -> void:
	update_scores()


func _on_in_game_menu_visibility_changed() -> void:
	pause_game_arena(%InGameMenu.is_visible_in_tree())
