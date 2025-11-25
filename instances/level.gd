extends Node2D
class_name Level


@export var number: int = 1

@onready var arena: Node2D = %Arena
@onready var enemies: Node2D = %Enemies
@onready var bombs: Node2D = %Bombs
@onready var explosions: Node2D = %Explosions
@onready var player: Player = %Player


var level_scores: int = 0
var enemy_list: Array[Node] = []
var crystal_list: Array[Node] = []
var player_start_position: Vector2
var is_extra_active: bool = false # activates when all the crystals are collected


signal scores_updated
signal all_crystals_collected
signal level_won


func _ready() -> void:
	enemy_list = get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemy_list:
		enemy.destroyed.connect(_on_enemy_destroyed.bind(enemy))
	
	player_start_position = %Player.position
	Mng.level = self


func _on_enemy_destroyed(enemy: Enemy) -> void:
	enemy_list.erase(enemy)
	level_scores += Mng.ENEMY_KILLED_POINTS
	if enemy_list.is_empty():
		level_won.emit()

# crystal_list is populated from the crystals themselevs in _ready and connected here
func _on_crystal_collected(crystal: Crystal) -> void:
	crystal_list.erase(crystal)
	level_scores += Mng.CRYSTAL_POINTS
	scores_updated.emit(level_scores)
	
	is_extra_active = crystal_list.is_empty()
	if is_extra_active:
		all_crystals_collected.emit()
