extends CharacterBody2D
class_name Bouncytiles


var MIN_SPEED = 100 # px/seconds


var direction: Vector2
var speed: float
var deceleration: float = 1.0
var is_moving: bool:
	set(value):
		is_moving = value
		%Particles.emitting = is_moving and speed > 2.0 * MIN_SPEED
		set_physics_process(is_moving)

var target_position: Vector2


func _ready() -> void:
	if Mng.is_publish:
		%Label.hide()
	target_position = position
	is_moving = false


func push(_direction: Vector2, _speed: float = Mng.TILE_SIZE.x * 10.0) -> void:
	if is_moving:
		return
	
	# check if against another block
	$RayCastTiles.target_position = _direction * Mng.TILE_SIZE
	$RayCastTiles.force_raycast_update()
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
		if speed <= MIN_SPEED:
			# Always snap back to default position
			is_moving = false
			position = position.snapped(Mng.TILE_SIZE) - Mng.TILE_SIZE/2.0
			target_position = position  # reset default
			return
		else:
			next_position()
	
	speed = lerpf(speed, 0, deceleration * delta)


func next_position() -> void:
	if $RayCastTiles.is_colliding():
		if speed <= MIN_SPEED:
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
	
	if body is Enemy:
		body.die()
		return
	if body is Player:
		body.take_damage(3.0)
		
		# snap tile's new position
		var new_position: Vector2 = position.snapped(Mng.TILE_SIZE) - Mng.TILE_SIZE/2.0
		
		#check if player pos (snapped) is equal to the tile pos (snapped)
		if new_position == Mng.level.player.target_position + Mng.TILE_SIZE/2.0:
			new_position = position - direction * Mng.TILE_SIZE
		
		#position = new_position
		target_position = new_position
		speed = MIN_SPEED
		#is_moving = false
