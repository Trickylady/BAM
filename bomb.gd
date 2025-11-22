extends Area2D
class_name bomb



var explosion_size = 1



func _on_timer_timeout() -> void:
	queue_free()
