extends Area2D
class_name Bomb


var explosion_size = 1
var is_exploded: bool = false


func explode() -> void:
	if is_exploded:
		return
	var central = preload("res://instances/central_explosion.tscn").instantiate()
	central.position = position
	central.size = explosion_size
	Mng.level.explosions.add_child.call_deferred(central)
	is_exploded = true
	queue_free()

func _on_timer_timeout() -> void:
	explode()


func _on_area_entered(_area: Area2D) -> void:
	explode()
