extends TextureRect
class_name GameOverlay


func _ready() -> void:
	Mng.level_ready.connect(_on_level_ready)


func _on_level_ready() -> void:
	Mng.level.scores_updated.connect(_on_level_scores_updated)


func _on_level_scores_updated() -> void:
	pass
