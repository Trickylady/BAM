extends StaticBody2D

class_name GroundTile


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	Mng.level.destroy_all_triggered.connect(destroy)


func destroy():
	$AnimatedSprite2D.play("destroyed")
	Mng.current_scores += Mng.GROUND_TILE_POINTS
	await $AnimatedSprite2D.animation_finished
	queue_free()
