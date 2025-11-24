extends CharacterBody2D
class_name Enemy


@export var move_time := 0.60   # how long to move one tile
@export var see_distance: int = 4   # how long to move one tile

var direction: Vector2i = Vector2i.ZERO
var target_position: Vector2
var is_moving := false
var is_shooting: bool = false
var is_dead: bool = false



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
	direction = Vector2i(random_dir.normalized())
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
	%Sprite.flip_h = direction == Vector2i.LEFT
	
	if direction == Vector2i.UP and %Sprite.animation != "snakewalkup":
		%Sprite.play("snakewalkup")
	elif direction == Vector2i.DOWN and %Sprite.animation != "snakewalkdown":
		%Sprite.play("snakewalkdown")
	elif direction.x != 0 and %Sprite.animation != "snakewalkside":
		%Sprite.play("snakewalkside")


func shoot() -> void:
	if is_shooting: return
	
	is_shooting = true
	is_moving = false
	await get_tree().create_timer(0.1).timeout
	var bullet: Bullet = preload("res://bullet.tscn").instantiate()
	bullet.position = position
	bullet.direction = Vector2(direction)
	Mng.level.enemies.add_child(bullet)
	await get_tree().create_timer(0.5).timeout
	is_shooting = false
	is_moving = true


func die() -> void:
	$SFXDie.play()
	%Sprite.play("snakedead")
	await %Sprite.animation_finished
	print("player dead")
