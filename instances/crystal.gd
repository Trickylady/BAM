extends Area2D

class_name Crystal

func pick_up() -> void:
	$crystalpickup.play()
	$crystalsprite.hide()

func _on_crystalpickup_finished() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pick_up_crystal()
		pick_up()
