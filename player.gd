extends CharacterBody2D
class_name Player


@export var move_time := 0.25   # how long to move one tile
@export var explosion_size: int = 1:
	set(value):
		explosion_size = clamp(value, 0, 10)
		$BombPlacementSys.explosion_size = explosion_size
@onready var bomb_placement_sys: BombPlacementSys = $BombPlacementSys


var max_bombs_at_once = 5
var health: float = Mng.PLAYER_MAX_HEALTH:
	set(value):
		health = clamp(value, 0, Mng.PLAYER_MAX_HEALTH)
		health_updated.emit()

var direction: Vector2i = Vector2i.ZERO
var is_dead: bool = false
var target_position: Vector2
var moving := false


signal health_updated

func _ready():
	position = position.snapped(Mng.TILE_SIZE)
	target_position = position
	#updatePointUI()


func pick_up_crystal(): #hey Cam this function is called by crystal.gd :D
	pass
	#collectedPoints += pointsPerCrystal
	#updatePointUI()
	
#func updatePointUI():
	#pointTxt.text = "Points: " + str(collectedPoints) 


func _physics_process(delta):
	if Input.is_action_just_pressed("plant_bomb"):
		bomb_placement_sys.place_bomb()
	
	if not moving:
		var input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		
		if input != Vector2.ZERO:
			if input.y > 0: direction = Vector2i.DOWN
			elif input.y < 0: direction = Vector2i.UP
			elif input.x > 0: direction = Vector2i.RIGHT
			elif input.x < 0: direction = Vector2i.LEFT
			var next_pos = position + Vector2(direction) * Mng.TILE_SIZE
			
			if not test_move(global_transform, Vector2(direction) * Mng.TILE_SIZE):
				target_position = next_pos
				moving = true
	
	if moving:
		position = position.move_toward(target_position, Mng.TILE_SIZE.x / move_time * delta)
		if position == target_position:
			moving = false


func _process(_delta: float) -> void:
	%info.text = %Sprite.animation
	%Sprite.flip_h = direction == Vector2i.RIGHT
	if moving:
		if direction == Vector2i.UP and %Sprite.animation != "walkup":
			%Sprite.play("walkup")
		elif direction == Vector2i.DOWN and %Sprite.animation != "walkdown":
			%Sprite.play("walkdown")
		elif direction.x != 0 and %Sprite.animation != "walkside":
			%Sprite.play("walkside")
	else: 
		if direction == Vector2i.UP and %Sprite.animation != "idleup":
			%Sprite.play("idleup")
		elif direction == Vector2i.DOWN and %Sprite.animation != "idledown":
			%Sprite.play("idledown")
		elif direction.x != 0 and %Sprite.animation != "idleside":
			%Sprite.play("idleside")


func take_damage(amount: float) -> void:
	health -= amount
	#updateHearts()
	if health <= 0.0:
		die()


func die():
	is_dead = true
	set_process(false)
	set_physics_process(false)
	$SFXDie.play()
	%Sprite.play("dragondead")
