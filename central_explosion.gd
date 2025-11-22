extends Area2D

class_name CenteralExplosion
@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/RayCastUp,
	$RayCasts/RayCastDown,
	$RayCasts/RayCastRight,
	$RayCasts/RayCastLeft
]

const DIRECTIONAL_EXPLOSION = preload("res://directional_explosion.tscn")

var size = 1

func _ready() -> void:
	check_raycasts()
	
func check_raycasts():
	var up_raycast = raycasts[0]
	up_raycast.target_position = up_raycast.target_position * size
	up_raycast.force_raycast_update()
	if !up_raycast.is_colliding():
		create_explosion_for_size(size, "up", Vector2(0, -70))
	else:
		var size_of_explosion = calculate_size_of_explosion(up_raycast)
		var collider = up_raycast.get_collider()
		if size_of_explosion != null:
			create_explosion_for_size(size, "up", Vector2(0, -70))
			
		execute_explosion_collision()
		
func create_explosion_for_size(size: int, animation_name: String, animation_position: Vector2):
	for i in size:
		if i < size - 1:
			create_explosion_animation_slice("%_middle" % animation_name, animation_position * (i+1))
		else:
			create_explosion_animation_slice("%_end" % animation_name, animation_position * (i+1))
			

func create_explosion_animation_slice(anim_name: String, anim_position: Vector2):
	var directional_explosion = DIRECTIONAL_EXPLOSION.instantiate()
	directional_explosion.position = anim_position
	add_child(directional_explosion)
	directional_explosion.play_animation(anim_name)

func calculate_size_of_explosion(raycast: RayCast2D):
	var collider = raycast.get_collider()
	if collider is TileMapLayer:
		var collisionPoint = raycast.get_collision_point()
	
		var distanceToColider = raycast.global_position.distance_to(collisionPoint)
		var size_of_explosion_before_collider = max(roundi(absf(distanceToColider) / 70 - 1), 0)
		return size_of_explosion_before_collider
		
func execute_explosion_collision(collider: Object):
	if collider is BrickWall:
		(collider as BrickWAll).destroy()
	
		
