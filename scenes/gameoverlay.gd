extends TextureRect
class_name GameOverlay




func _ready() -> void:
	Mng.level_ready.connect(_on_level_ready)


func update_all() -> void:
	update_scores()
	update_lives()
	update_health()
	update_bombs()


func update_lives() -> void:
	%LabelLives.text = "x%d" % Mng.dragon_lives


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


func update_scores() -> void:
	%LabelScores.text = "%05d" % (Mng.global_scores + Mng.current_scores)


func _on_level_ready() -> void:
	Mng.scores_updated.connect(_on_scores_updated)
	Mng.health_updated.connect(update_health)
	Mng.lives_updated.connect(update_lives)
	Mng.level.player.bombs_updated.connect(update_bombs)
	update_all()


func _on_scores_updated() -> void:
	update_scores()
