extends CharacterBody2D
class_name Enemy


@export var move_time := 0.60   # how long to move one tile
@export var see_distance: int = 4   # how long to move one tile
@export var shoot_cooldown: float = 0.8 # seconds
@export var bullet_speed: float = Mng.TILE_SIZE.x * 4.0 # pixels/seconds

var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
var is_moving := false
var is_shooting: bool = false
var is_dead: bool = false

signal destroyed



func _ready() -> void:
	position = position.snapped(Mng.TILE_SIZE)
	target_position = position
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	set_physics_process(true)


func find_new_target() -> void:
	var possible_targets: Array = []
	for ray: RayCast2D in %movementrays.get_children():
		if ray.is_colliding():
			continue
		possible_targets.append(ray.target_position)
	var random_dir: Vector2 = possible_targets.pick_random()
	target_position = position + random_dir
	direction = Vector2(random_dir.normalized())
	$RayPlayerDetect.target_position = Vector2(direction) * Mng.TILE_SIZE * see_distance


func _physics_process(delta: float) -> void:
	if not is_shooting and $RayPlayerDetect.get_collider() is Player:
		shoot()
		return
	if not is_moving and not is_shooting:
		find_new_target()
		is_moving = true
	if is_moving:
		position = position.move_toward(target_position, Mng.TILE_SIZE.x / move_time * delta)
		if position == target_position:
			is_moving = false


func _process(_delta: float) -> void:
	%info.text = %Sprite.animation
	%Sprite.flip_h = direction == Vector2.LEFT
	
	if Mng.level.is_extra_active:
		if direction == Vector2.UP and %Sprite.animation != "extrasnakeup":
			%Sprite.play("extrasnakeup")
		elif direction == Vector2.DOWN and %Sprite.animation != "extrasnakedown":
			%Sprite.play("extrasnakedown")
		elif direction.x != 0 and %Sprite.animation != "extrasnakeside":
			%Sprite.play("extrasnakeside")
	else:
		if direction == Vector2.UP and %Sprite.animation != "snakewalkup":
			%Sprite.play("snakewalkup")
		elif direction == Vector2.DOWN and %Sprite.animation != "snakewalkdown":
			%Sprite.play("snakewalkdown")
		elif direction.x != 0 and %Sprite.animation != "snakewalkside":
			%Sprite.play("snakewalkside")


func shoot() -> void:
	if is_shooting: return
	
	is_shooting = true
	is_moving = false
	await get_tree().create_timer(0.1).timeout
	var bullet: Bullet = preload("res://instances/bullet.tscn").instantiate()
	bullet.speed = bullet_speed
	bullet.position = position
	bullet.direction = direction
	Mng.level.bullets.add_child(bullet)
	await get_tree().create_timer(shoot_cooldown).timeout
	is_shooting = false
	is_moving = true


func die() -> void:
	is_dead = true
	destroyed.emit()
	$Collision.set_deferred(&"disabled", true)
	set_process(false)
	set_physics_process(false)
	$SFXDie.play()
	%Sprite.play("snakedead")
	await %Sprite.animation_finished
	queue_free()
