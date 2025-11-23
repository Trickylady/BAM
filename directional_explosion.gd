extends Area2D
class_name DirectionalExplosion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

	# Connect the animation_finished signal
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func play_anim(animation_name: String):
	animated_sprite_2d.play(animation_name)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if body.is_in_group("Player"):
			body.die()
		elif body.is_in_group("Enemy"):
			body.queue_free()  # or call enemy damage logic

func _on_animation_finished():
	queue_free()
