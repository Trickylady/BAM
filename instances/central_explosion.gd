extends Area2D

class_name CenteralExplosion
@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/RayCastUp,
	$RayCasts/RayCastDown,
	$RayCasts/RayCastRight,
	$RayCasts/RayCastLeft
]


var animation_names = ["up", "right", "down", "left"]
var anim_dirs: Array[Vector2] = [
	Vector2(0, -70),
	Vector2(70, 0),
	Vector2(0, 70),
	Vector2(-70, 0)
]

var size = 1

func _ready() -> void:
	check_raycasts()
	
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Auto-remove this node after a short delay
	var timer := Timer.new()
	timer.wait_time = 0.6  # adjust to match explosion duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timeout)

func _on_timeout():
	queue_free()
	
func check_raycasts():
	for i in raycasts.size():
		check_raycast_directions(animation_names[i], raycasts[i], anim_dirs[i])


func check_raycast_directions(anim_name: String, raycast: RayCast2D, animDir: Vector2):
	raycast.target_position = animDir * size
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		create_explosion_for_size(size, anim_name, animDir)
	else:
		var size_explosion = calculate_size_of_explosion(raycast)
		var collider = raycast.get_collider()
		if size_explosion != null:
			create_explosion_for_size(size_explosion, anim_name, animDir)
		execute_explosion_collision(collider)


func create_explosion_for_size(explosion_size: int, animation_name: String, animation_position: Vector2):
	for i in explosion_size:
		if i < explosion_size - 1:
			create_explosion_animation_slice("%s_middle" % animation_name, animation_position * (i+1))
		else:
			create_explosion_animation_slice("%s_end" % animation_name, animation_position * (i+1))


func create_explosion_animation_slice(anim_name: String, anim_position: Vector2):
	var directional_explosion = preload("res://instances/directional_explosion.tscn").instantiate()
	directional_explosion.position = anim_position
	add_child(directional_explosion)
	directional_explosion.play_anim(anim_name)


func calculate_size_of_explosion(raycast: RayCast2D):
	var collider = raycast.get_collider()
	if collider is TileMapLayer:
		var collisionPoint = raycast.get_collision_point()
	
		var distanceToCollider = raycast.global_position.distance_to(collisionPoint)
		var size_of_explosion_before_collider = max(roundi(absf(distanceToCollider) / Mng.TILE_SIZE.x - 1), 0)
		return size_of_explosion_before_collider


func execute_explosion_collision(collider: Object):
	if collider is GroundTile:
		collider.destroy()


func damage_overlapping_bodies():
	for body in get_overlapping_bodies():
		if body is Player:
			(body as Player).take_damage(0.5)

	
func _on_body_entered(body: Node) -> void:
	if body is Player:
		(body as Player).take_damage(0.5)
		
