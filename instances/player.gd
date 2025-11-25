extends CharacterBody2D
class_name Player

@onready var bomb_placement_sys: BombPlacementSys = $BombPlacementSys

@export var walk_speed := Mng.TILE_SIZE.x * 4.0

var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
var moving := false

var is_dead: bool = false: set = set_is_dead
var is_invincible: bool = false: set = set_is_invincible
var has_speed_boost: bool = false
var has_shield_boost: bool = false

signal died


#region Bombs
var max_bombs_at_once: int = Mng.START_MAX_BOMBS:
	set(value):
		max_bombs_at_once = value
		bombs_updated.emit()
var bombs_placed: int = 0:
	set(value):
		bombs_placed = value
		bombs_updated.emit()
var explosion_size: int = Mng.START_EXPLOSION_SIZE:
	set(value):
		explosion_size = max(value, 1)
		bombs_updated.emit()

signal bombs_updated
#endregion



func _ready():
	position = position.snapped(Mng.TILE_SIZE)
	target_position = position
	%Sprite.play("idledown")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"plant_bomb"):
		bomb_placement_sys.place_bomb()
	
	if not moving and Input.is_action_just_pressed(&"push"):
		try_push()
	
	if not moving:
		var input = Vector2(
			Input.get_action_strength(&"right") - Input.get_action_strength(&"left"),
			Input.get_action_strength(&"down") - Input.get_action_strength(&"up")
		)
		
		if input != Vector2.ZERO:
			if input.y > 0: direction = Vector2.DOWN
			elif input.y < 0: direction = Vector2.UP
			elif input.x > 0: direction = Vector2.RIGHT
			elif input.x < 0: direction = Vector2.LEFT
			%RayCastTiles.target_position = direction * Mng.TILE_SIZE
			var next_pos = position + direction * Mng.TILE_SIZE
			
			if not test_move(global_transform, direction * Mng.TILE_SIZE):
				target_position = next_pos
				moving = true
	
	if moving:
		var final_speed: float = walk_speed
		if has_speed_boost:
			final_speed *= Mng.BOOST_SPEED_MULTIPLIER
		final_speed *= delta
		position = position.move_toward(target_position, final_speed)
		if position == target_position:
			moving = false


func _process(_delta: float) -> void:
	%info.text = %Sprite.animation
	%Sprite.flip_h = direction == Vector2.RIGHT
	if has_shield_boost:
		if direction == Vector2.UP and %Sprite.animation != "shieldwalkup":
			%Sprite.play("shieldwalkup")
		elif direction == Vector2.DOWN and %Sprite.animation != "shieldwalkdown":
			%Sprite.play("shieldwalkdown")
		elif direction.x != 0 and %Sprite.animation != "shieldwalkside":
			%Sprite.play("shieldwalkside")
	elif moving:
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


func try_push() -> void:
	if not %RayCastTiles.is_colliding():
		return
	
	var collider = %RayCastTiles.get_collider()
	var label: PopupLabel = preload("res://instances/popup_label.tscn").instantiate()
	if collider is Bouncytiles:
		%SFXPush.play()
		label.text = "Bounce!"
		collider.push(direction)
	elif collider is GroundTile:
		%SFXCantPush.play()
		label.text = "Can't!"
	else:
		%SFXCantPush.play()
		label.text = "No!"
	add_child(label)


func take_damage(amount: float) -> void:
	if is_invincible:
		return
	if has_shield_boost:
		return
	is_invincible = true
	Mng.dragon_health -= amount
	if Mng.dragon_health <= 0.0:
		die()
	else:
		%SFXHurt.play()


func pick_up(obj: PickUp) -> void:
	Mng.current_scores += obj.points
	
	match obj.type:
		PickUp.Type.CRYSTAL:
			pass
		PickUp.Type.SPEED:
			has_speed_boost = true
			%TimerSpeedBoost.start()
		PickUp.Type.SHIELD:
			has_shield_boost = true
			%TimerShieldBoost.start()
		PickUp.Type.EXTRA_BOMB:
			max_bombs_at_once += 1
		PickUp.Type.BIGGER_EXPLOSION:
			explosion_size += 1
		PickUp.Type.DESTROY_TILES:
			Mng.level.destroy_all_tiles()
		PickUp.Type.KILL_ENEMY:
			Mng.level.kill_random_enemy()
		PickUp.Type.EXTRA_LIFE:
			Mng.dragon_lives += 1
		PickUp.Type.EXTRA_HEALTH:
			Mng.dragon_health += 3.0


func die() -> void:
	if has_shield_boost:
		return
	if is_dead:
		return
	Mng.dragon_health = 0
	is_dead = true
	%SFXDie.play()
	%Sprite.play("dragondead")
	await get_tree().create_timer(Mng.RESPAWN_TIME_AFTER_DEATH).timeout
	Mng.dragon_lives -= 1
	died.emit()


func respawn() -> void:
	%Sprite.play("idledown")
	Mng.dragon_health = Mng.PLAYER_MAX_HEALTH
	is_dead = false
	position = position.snapped(Mng.TILE_SIZE) #Mng.level.player_start_position
	target_position = position
	is_invincible = true
	$SpawnParticles.emitting = true


func set_is_dead(value: bool) -> void:
	is_dead = value
	$Collision.set_deferred(&"disabled", value)
	set_process(not value)
	set_physics_process(not value)


func set_is_invincible(value: bool) -> void:
	is_invincible = value
	if is_invincible:
		# the animation player will call set_is_invincible(false) at the end
		%AnimationInvincible.play(&"invincible")
	


func _on_timer_speed_boost_timeout() -> void:
	has_speed_boost = false
func _on_timer_shield_boost_timeout() -> void:
	has_shield_boost = false
