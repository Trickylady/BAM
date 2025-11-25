extends Node2D
class_name Level


@onready var gameoverlay: GameOverlay = %Gameoverlay
@onready var arena: Node2D = %Arena
@onready var enemies: Node2D = %Enemies
@onready var bombs: Node2D = %Bombs
@onready var explosions: Node2D = %Explosions
@onready var bullets: Node2D = %Bullets
@onready var player: Player = %Player


var enemy_list: Array[Node] = []
var crystal_list: Array[Node] = []
var player_start_position: Vector2
var is_extra_active: bool = false # activates when all the crystals are collected


signal all_crystals_collected
signal destroy_all_triggered
signal level_won


func _ready() -> void:
	enemy_list = get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemy_list:
		enemy.destroyed.connect(_on_enemy_destroyed.bind(enemy))
	
	player_start_position = %Player.position
	Mng.level = self


func clear_projectiles() -> void:
	for child: Bullet in bullets.get_children():
		child.queue_free()


func destroy_all_tiles() -> void:
	destroy_all_triggered.emit()


func kill_random_enemy() -> void:
	var random_enemy: Enemy = enemy_list.pick_random()
	random_enemy.die()


func _on_enemy_destroyed(enemy: Enemy) -> void:
	enemy_list.erase(enemy)
	var mult: float = Mng.ENEMY_KILLED_MULTIPLIER_CRYSTALS if is_extra_active else 1.0
	var scores: int = int(Mng.ENEMY_KILLED_POINTS * mult)
	Mng.current_scores += scores
	if enemy_list.is_empty():
		level_won.emit()


# crystal_list is populated from the crystals themselevs in _ready and connected here
func _on_crystal_collected(crystal: PickUp) -> void:
	crystal_list.erase(crystal)
	is_extra_active = crystal_list.is_empty()
	if is_extra_active:
		all_crystals_collected.emit()
