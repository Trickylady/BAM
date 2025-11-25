extends CharacterBody2D
class_name Bouncytiles


const MIN_SPEED = 10 # px/seconds

var direction: Vector2
var default_spawn_point: Vector2
var speed: float
var deceleration: float = 1.0
var is_moving: bool:
	set(value):
		is_moving = value
		%Particles.emitting = is_moving and speed > MIN_SPEED
		set_physics_process(is_moving)

var target_position: Vector2


func _ready() -> void:
	target_position = position
	if Mng.level.player:
		default_spawn_point = Mng.level.player.position

	is_moving = false


func push(_direction: Vector2, _speed: float = Mng.TILE_SIZE.x * 10.0) -> void:
	if is_moving:
		return
	
	# check if against another block
	$RayCastTiles.target_position = _direction * Mng.TILE_SIZE
	await get_tree().process_frame
	if $RayCastTiles.is_colliding():
		return
	
	# apply direction speed and activate the physics process
	direction = _direction
	next_position()
	speed = _speed
	is_moving = true


func _physics_process(delta: float) -> void:
	position = position.move_toward(target_position, speed * delta)
	
	if position == target_position:
		if speed <= 6 * MIN_SPEED:
			# Always snap back to default position
			is_moving = false
			position = position.snapped(Mng.TILE_SIZE) - Mng.TILE_SIZE/2.0
			target_position = position  # reset default
			return
		else:
			next_position()
	
	speed = lerpf(speed, MIN_SPEED, deceleration * delta)


func next_position() -> void:
	# TODO: check what's ahead
	if $RayCastTiles.is_colliding():
		if speed <= 6 * MIN_SPEED:
			is_moving = false
			position = position.snapped(Mng.TILE_SIZE) - Mng.TILE_SIZE/2.0
			return
		else:
			direction = -direction
			$RayCastTiles.target_position = direction * Mng.TILE_SIZE
	
	target_position = position + direction * Mng.TILE_SIZE


func _on_hit_area_body_entered(body: Node2D) -> void:
	if not is_moving:
		return
	position = position.snapped(Mng.TILE_SIZE) - Mng.TILE_SIZE/2.0
	
	if position == Mng.level.player.target_position:
		position = position - direction * Mng.TILE_SIZE

	if body is Player:
		body.take_damage(3.0)
		if body.is_invincible:
			Mng.level.player.position = default_spawn_point




	if body is Enemy:
		body.die()
	
