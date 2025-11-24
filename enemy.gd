extends CharacterBody2D
class_name  Enemy


@export var tile_size := 70
@export var move_time := 0.25   # how long to move one tile

var direction: Vector2i = Vector2i.ZERO
var is_dead: bool = false

var target_position: Vector2
var moving := false

func _ready():
	#position = position.snapped(Vector2(tile_size, tile_size))
	target_position = position

func find_new_target():
	var possible_targets : Array = []
	for ray: RayCast2D in %movementrays.get_children():
		if ray.is_colliding():
			continue
		possible_targets.append(ray.target_position)
	var random_dir: Vector2 = possible_targets.pick_random()
	target_position = global_position + random_dir
	direction = Vector2i(random_dir.normalized())

func _physics_process(delta):
	if not moving:
		find_new_target()
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
