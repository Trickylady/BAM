extends Area2D
class_name DirectionalExplosion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)
	check_bombs.call_deferred()

func check_bombs():
	var areas = get_overlapping_areas() 
	print(areas)
	for area: Area2D in areas:
		if area.has_method("explode"):
			area.explode()

func play_anim(animation_name: String):
	animated_sprite_2d.play(animation_name)

func _on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		body.die()
