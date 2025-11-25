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
var crystals_collected: int = 0:
	set(value):
		crystals_collected = value
		crystals_collected_updated.emit()
var crystals_total: int = 0:
	set(value):
		crystals_total = value
		crystals_collected_updated.emit()
var player_start_position: Vector2
var red_mode_active: bool = false # activates when all the crystals are collected


signal crystals_collected_updated
signal all_crystals_collected
signal destroy_all_triggered
signal level_won
signal level_lost


func _ready() -> void:
	enemy_list = get_tree().get_nodes_in_group("enemies")
	for enemy: Enemy in enemy_list:
		enemy.destroyed.connect(_on_enemy_destroyed.bind(enemy))
	
	player_start_position = %Player.position
	%TimerRedMode.wait_time = Mng.RED_MODE_DURATION
	%TimerLevel.wait_time = Mng.LEVEL_TIME
	
	player.died.connect(_on_player_died)
	
	Mng.level = self
	await get_tree().process_frame
	crystals_total = crystal_list.size()


func clear_projectiles() -> void:
	for child: Bullet in bullets.get_children():
		child.queue_free()


func destroy_all_tiles() -> void:
	destroy_all_triggered.emit()


func kill_random_enemy() -> void:
	var random_enemy: Enemy = enemy_list.pick_random()
	random_enemy.die()


func _on_player_died() -> void:
	if Mng.dragon_lives <= 0:
		level_lost.emit()
		gameoverlay.go_to_game_over()
	else:
		clear_projectiles()
		player.respawn()


func _on_enemy_destroyed(enemy: Enemy) -> void:
	enemy_list.erase(enemy)
	var mult: float = Mng.RED_MODE_POINTS_MULTIPLIER if red_mode_active else 1.0
	var scores: int = int(Mng.ENEMY_KILLED_POINTS * mult)
	Mng.current_scores += scores
	if enemy_list.is_empty():
		level_won.emit()
		await get_tree().create_timer(Mng.RESPAWN_TIME_AFTER_DEATH).timeout
		gameoverlay.go_to_win_screen()


# crystal_list is populated from the crystals themselevs in _ready and connected here
func _on_crystal_collected(crystal: PickUp) -> void:
	crystal_list.erase(crystal)
	crystals_collected += 1
	red_mode_active = crystal_list.is_empty()
	if red_mode_active:
		%TimerRedMode.start()
		all_crystals_collected.emit()


func _on_timer_red_mode_timeout() -> void:
	red_mode_active = false
