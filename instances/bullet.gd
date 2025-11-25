extends Area2D
class_name Bullet


var direction: Vector2
var speed: float = Mng.TILE_SIZE.x
var damage: float = 0.5


func _ready() -> void:
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func destroy() -> void:
	$Sprite.hide()
	$Collision.set_deferred(&"disabled", true)
	set_physics_process(false)
	$SFXHit.play()
	await $SFXHit.finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
	destroy()


func _on_timer_timeout() -> void:
	destroy()
