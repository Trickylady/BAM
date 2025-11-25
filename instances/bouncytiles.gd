extends CharacterBody2D
class_name Bouncytiles


const MIN_SPEED = 10 # px/seconds

var direction: Vector2
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
	is_moving = false


func push(_direction: Vector2, _speed: float = Mng.TILE_SIZE.x * 10.0) -> void:
	if is_moving:
		return
	direction = _direction
	speed = _speed
	is_moving = true


func _physics_process(delta: float) -> void:
	# TODO
	position = position.move_toward(target_position, speed * delta)
	if position == target_position:
		if speed < 4 * MIN_SPEED:
			is_moving = false
			position = position.snapped(Mng.TILE_SIZE / 2.0)
			return
		else:
			next_position()
	#target_position
	speed = lerpf(speed, MIN_SPEED, deceleration * delta)


func next_position() -> void:
	# TODO: check what's ahead
	target_position = position + direction * Mng.TILE_SIZE
