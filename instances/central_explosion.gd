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

var explosion_size: int = 1

func _ready() -> void:
	check_raycasts()
	await get_tree().process_frame
	await get_tree().process_frame
	for body: Node2D in get_overlapping_bodies():
		check_body(body)


func check_body(body: PhysicsBody2D) -> void:
	if body.has_method("die"):
		body.die()


func check_raycasts():
	for i in raycasts.size():
		check_raycast_directions(animation_names[i], raycasts[i], anim_dirs[i])


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.hide()
	$Collision.set_deferred(&"disabled", true)
	for child: DirectionalExplosion in $Directionals.get_children():
		child.queue_free()
	if $SFXExplosion.playing:
		await $SFXExplosion.finished
	queue_free()



func check_raycast_directions(anim_name: String, raycast: RayCast2D, animDir: Vector2):
	raycast.target_position = animDir * explosion_size
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		create_explosion_for_size(explosion_size, anim_name, animDir)
	else:
		var size_explosion = calculate_size_of_explosion(raycast)
		var collider = raycast.get_collider()
		if size_explosion != null:
			create_explosion_for_size(size_explosion, anim_name, animDir)
		if collider is GroundTile:
			collider.destroy()


func create_explosion_for_size(calculated_size: int, animation_name: String, animation_position: Vector2):
	for i in calculated_size:
		if i < calculated_size - 1:
			create_explosion_animation_slice("%s_middle" % animation_name, animation_position * (i+1))
		else:
			create_explosion_animation_slice("%s_end" % animation_name, animation_position * (i+1))


func create_explosion_animation_slice(anim_name: String, anim_position: Vector2):
	var directional_explosion: DirectionalExplosion = preload("res://instances/directional_explosion.tscn").instantiate()
	directional_explosion.position = anim_position
	$Directionals.add_child(directional_explosion)
	directional_explosion.play_anim(anim_name)


func calculate_size_of_explosion(raycast: RayCast2D):
	var collider = raycast.get_collider()
	if collider is TileMapLayer:
		var collisionPoint = raycast.get_collision_point()
	
		var distanceToCollider = raycast.global_position.distance_to(collisionPoint)
		var size_of_explosion_before_collider = max(roundi(absf(distanceToCollider) / Mng.TILE_SIZE.x - 1), 0)
		return size_of_explosion_before_collider


func _on_body_entered(body: Node) -> void:
	check_body(body)
