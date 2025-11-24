extends Area2D
class_name DirectionalExplosion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	for body: Node2D in get_overlapping_bodies():
		check_body(body)


func check_body(body: PhysicsBody2D) -> void:
	if body.has_method("die"):
		body.die()


func play_anim(animation_name: String):
	animated_sprite_2d.play(animation_name)


func _on_body_entered(body: PhysicsBody2D) -> void:
	check_body(body)
