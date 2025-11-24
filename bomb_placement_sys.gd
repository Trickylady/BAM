extends Node

class_name BombPlacementSys

const BOMB_SCENE = preload("res://bomb.tscn")


var explosion_size: int = 1
var bombs_placed = 0
var player: Player = null


func _ready() -> void:
	player = get_parent()


func place_bomb():
	if bombs_placed >= player.max_bombs_at_once:
		return
	
	var new_bomb_position: Vector2 = player.position.snapped(Mng.TILE_SIZE)
	if not can_place(new_bomb_position):
		return
	
	var bomb: Bomb = BOMB_SCENE.instantiate()
	
	bomb.explosion_size = explosion_size
	bomb.position = new_bomb_position
	Mng.level.bombs.add_child(bomb)
	bombs_placed += 1
	bomb.tree_exiting.connect(on_bomb_exploded)


func can_place(new_bomb_position: Vector2) -> bool:
	for bomb: Bomb in get_tree().get_nodes_in_group("bombs"):
		if bomb.position == new_bomb_position:
			return false
	return true


func on_bomb_exploded():
	bombs_placed -= 1
