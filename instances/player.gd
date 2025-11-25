extends CharacterBody2D
class_name Player


@export var move_time := 0.25   # how long to move one tile
@export var explosion_size: int = 1:
	set(value):
		explosion_size = clamp(value, 0, 10)
		$BombPlacementSys.explosion_size = explosion_size

@onready var bomb_placement_sys: BombPlacementSys = $BombPlacementSys

var max_bombs_at_once = 5

var direction: Vector2 = Vector2.ZERO
var is_dead: bool = false: set = set_is_dead
var target_position: Vector2
var moving := false


func _ready():
	position = position.snapped(Mng.TILE_SIZE)
	target_position = position


func pick_up_crystal() -> void:
	Mng.level.level_scores += Mng.CRYSTAL_POINTS


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("plant_bomb"):
		bomb_placement_sys.place_bomb()
	
	if not moving:
		var input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		
		if input != Vector2.ZERO:
			if input.y > 0: direction = Vector2.DOWN
			elif input.y < 0: direction = Vector2.UP
			elif input.x > 0: direction = Vector2.RIGHT
			elif input.x < 0: direction = Vector2.LEFT
			var next_pos = position + direction * Mng.TILE_SIZE
			
			if not test_move(global_transform, direction * Mng.TILE_SIZE):
				target_position = next_pos
				moving = true
	
	if moving:
		position = position.move_toward(target_position, Mng.TILE_SIZE.x / move_time * delta)
		if position == target_position:
			moving = false


func _process(_delta: float) -> void:
	%info.text = %Sprite.animation
	%Sprite.flip_h = direction == Vector2.RIGHT
	if moving:
		if direction == Vector2.UP and %Sprite.animation != "walkup":
			%Sprite.play("walkup")
		elif direction == Vector2.DOWN and %Sprite.animation != "walkdown":
			%Sprite.play("walkdown")
		elif direction.x != 0 and %Sprite.animation != "walkside":
			%Sprite.play("walkside")
	else: 
		if direction == Vector2.UP and %Sprite.animation != "idleup":
			%Sprite.play("idleup")
		elif direction == Vector2.DOWN and %Sprite.animation != "idledown":
			%Sprite.play("idledown")
		elif direction.x != 0 and %Sprite.animation != "idleside":
			%Sprite.play("idleside")


func take_damage(amount: float) -> void:
	Mng.dragon_health -= amount
	if Mng.dragon_health <= 0.0:
		die()


func die() -> void:
	Mng.dragon_health = 0
	is_dead = true
	$SFXDie.play()
	%Sprite.play("dragondead")
	await get_tree().create_timer(Mng.RESPAWN_TIME_AFTER_DEATH).timeout
	Mng.dragon_lives -= 1
	if Mng.dragon_lives <= 0:
		Mng.go_to_gameover_screen()
	else:
		respawn()


func respawn() -> void:
	%Sprite.play("idledown")
	is_dead = false
	position = Mng.level.player_start_position
	$SpawnParticles.emitting = true


func set_is_dead(value: bool) -> void:
	is_dead = value
	$Collision.set_deferred(&"disabled", value)
	set_process(not value)
	set_physics_process(not value)
