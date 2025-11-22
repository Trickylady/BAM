extends Node2D

@export var fuse_time := 2.0          # seconds before explosion
@export var explosion_range := 3      # tiles in each direction
@export var tile_size := 72           # match your grid size

@onready var fuse_timer: Timer = $Timer

func _ready():
	# Snap bomb to grid
	position = position.snapped(Vector2(tile_size, tile_size))
	fuse_timer.wait_time = fuse_time
	fuse_timer.start()

func _on_Timer_timeout():
	explode()

func explode():
	# Replace bomb sprite with explosion animation
	queue_free()  # remove bomb itself

	# Spawn explosion in 4 directions
	for dir in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
		propagate_explosion(dir)

func propagate_explosion(direction: Vector2):
	var current_pos = position
	for i in range(explosion_range):
		current_pos += direction * tile_size

		# Check collision before placing explosion
		if is_blocked(current_pos):
			break

		spawn_explosion(current_pos)

func is_blocked(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state

	var params = PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var result = space_state.intersect_point(params)
	return result.size() > 0

func spawn_explosion(pos: Vector2):
	var explosion = preload("res://Explosion.tscn").instantiate()
	explosion.position = pos
	get_parent().add_child(explosion)
