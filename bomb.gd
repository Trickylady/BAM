extends Area2D
class_name Bomb

const CENTRAL_EXPLOSION = preload("res://central_explosion.tscn")

var explosion_size = 1
var is_exploded: bool = false

func explode() -> void:
	if is_exploded:
		return
	var central = CENTRAL_EXPLOSION.instantiate()
	central.position = position
	central.size = explosion_size
	get_parent().add_child.call_deferred(central)
	is_exploded = true
	queue_free()

func _on_timer_timeout() -> void:
	explode()
