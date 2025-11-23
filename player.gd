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

var max_bombs_at_once = 1
var lives = 5.5

var target_position: Vector2
var moving := false

func _ready():
	position = position.snapped(Vector2(tile_size, tile_size))
	target_position = position

func _physics_process(delta):
	
	if Input.is_action_just_pressed("plant_bomb"):
		bomb_placement_sys.place_bomb()
	
	if not moving:
		var input = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)

		if input != Vector2.ZERO:
			# Clamp to 4 directions only
			if abs(input.x) > abs(input.y):
				input.y = 0
			else:
				input.x = 0

			var next_pos = position + input * tile_size

			# Collision check before moving
			if not test_move(global_transform, input * tile_size):
				target_position = next_pos
				moving = true

	if moving:
		position = position.move_toward(target_position, tile_size / move_time * delta)
		if position == target_position:
			moving = false
			
func die():
	if lives > 0:
		lives -= 0.5
		
		if lives > 5.0:
			if lives == 5.5:
				heart6.texture = lifefulltex
