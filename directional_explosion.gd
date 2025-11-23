extends Area2D
class_name DirectionalExplosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func play_anim(animation_name: String):
	animated_sprite_2d.play(animation_name)


func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		# Example: damage player or enemy
		if body.is_in_group("Player"):
			body.die()
		elif body.is_in_group("Enemy"):
			body.queue_free()  # or call enemy damage logic
