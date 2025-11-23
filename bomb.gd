extends Area2D
class_name bomb

const CENTRAL_EXPLOSION = preload("res://central_explosion.tscn")

var explosion_size = 1

func _on_timer_timeout() -> void:
	var explode = CENTRAL_EXPLOSION.instantiate()
	explode.position = position
	explode.size = explosion_size
	get_tree().root.add_child(explode)
	queue_free()
