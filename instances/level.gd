extends Node2D
class_name Level


@export var number: int = 1

@onready var arena: Node2D = %Arena
@onready var enemies: Node2D = %Enemies
@onready var bombs: Node2D = %Bombs
@onready var explosions: Node2D = %Explosions


var level_scores: int = 0
var enemy_list: Array[Node] = []
var crystal_list: Array[Node] = []


signal scores_updated
signal level_won


func _ready() -> void:
	enemy_list = get_tree().get_nodes_in_group("enemies")
	crystal_list = get_tree().get_nodes_in_group("crystals")
	for enemy: Enemy in enemy_list:
		enemy.tree_exited.connect(_on_enemy_freed.bind(enemy))
	for crystal: Crystal in crystal_list:
		crystal.tree_exited.connect(_on_crystal_freed.bind(crystal))
	
	Mng.level = self


func check_win() -> void:
	if enemy_list.is_empty():
		level_won.emit()
		print("Level won")


func _on_enemy_freed(enemy: Enemy) -> void:
	enemy_list.erase(enemy)
	level_scores += Mng.ENEMY_KILLED_POINTS
	check_win()


func _on_crystal_freed(crystal: Crystal) -> void:
	crystal_list.erase(crystal)
	level_scores += Mng.CRYSTAL_POINTS
	scores_updated.emit(level_scores)
