extends CharacterBody2D


class_name Player

@export var tile_size := 70
@export var move_time := 0.25   # how long to move one tile
@onready var bomb_placement_sys: BombPlacementSys = $BombPlacementSys
@onready var lifefulltex: Texture2D =  load("res://life_full.png")
@onready var lifehalftex: Texture2D =  load("res://life_half.png")
@onready var life_empty_tex: Texture2D = load("res://life_empty.png")

@onready var heart1: Sprite2D = $"../Heart"
@onready var heart2: Sprite2D = $"../Heart2"
@onready var heart3: Sprite2D = $"../Heart3"
@onready var heart4: Sprite2D = $"../Heart4"
@onready var heart5: Sprite2D = $"../Heart5"
@onready var heart6: Sprite2D = $"../Heart6"

var max_bombs_at_once = 5
var health = 5.5
var direction: Vector2i = Vector2i.ZERO
var is_dead: bool = false

var target_position: Vector2
var moving := false

func _ready():
	#position = position.snapped(Vector2(tile_size, tile_size)/2)
	target_position = position

func pick_up_crystal(): #hey Cam this function is called by crystal.gd :D
	print("crystal picked up")

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
			# Clamp to 4 directions only
			#if abs(input.x) > abs(input.y):
				#input.y = 0
			#else:
				#input.x = 0

			var next_pos = position + Vector2(direction) * tile_size

			# Collision check before moving
			if not test_move(global_transform, Vector2(direction) * tile_size):
				target_position = next_pos
				moving = true

	if moving:
		position = position.move_toward(target_position, tile_size / move_time * delta)
		if position == target_position:
			moving = false
			
func _process(_delta: float) -> void:
	%info.text = $Dragon.animation
	#%info.text = "%s, %s" % [direction, moving]
	#if direction == Vector2i.RIGHT and not $Dragon.flip_h:
		#$Dragon.flip_h = true
	$Dragon.flip_h = direction == Vector2i.RIGHT
	if moving:
		if direction == Vector2i.UP and $Dragon.animation != "walkup":
			$Dragon.play("walkup")
		elif direction == Vector2i.DOWN and $Dragon.animation != "walkdown":
			$Dragon.play("walkdown")
		elif direction.x != 0 and $Dragon.animation != "walkside":
			$Dragon.play("walkside")
	else: 
		if direction == Vector2i.UP and $Dragon.animation != "idleup":
			$Dragon.play("idleup")
		elif direction == Vector2i.DOWN and $Dragon.animation != "idledown":
			$Dragon.play("idledown")
		elif direction.x != 0 and $Dragon.animation != "idleside":
			$Dragon.play("idleside")

func take_damage(amount: float):
	health -= amount
	print("damage taken")
	if health <= 0:
		die()

func die():
	$SFXDie.play()
	$Dragon.play("dragondead")
	print("player dead")
