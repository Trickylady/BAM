extends StaticBody2D

class_name GroundTile

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func destroy():
	$AnimatedSprite2D.play("destroyed")
	await $AnimatedSprite2D.animation_finished
	queue_free()
