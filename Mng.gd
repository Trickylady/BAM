extends Node


const TILE_SIZE: Vector2 = Vector2(70, 70)
const CRYSTAL_POINTS: int = 250
const ENEMY_KILLED_POINTS: int = 250
const PLAYER_MAX_HEALTH: float = 6.0
const START_LIVES: int = 3


var global_scores: int = 0
var current_level_num: int = 0

var dragon_lives: int = START_LIVES:
	set(value):
		dragon_lives = value
		lives_updated.emit()
signal lives_updated

var dragon_health: float = Mng.PLAYER_MAX_HEALTH:
	set(value):
		dragon_health = clamp(value, 0, Mng.PLAYER_MAX_HEALTH)
		health_updated.emit()

signal health_updated

var level: Level:
	set(value):
		level = value
		level_ready.emit()

signal level_ready

var level_paths = [
	"res://level_1.tscn",
	"res://level_1.tscn",
]


func start_game() -> void:
	reset_stats()
	go_to_next_level()


func reset_stats() -> void:
	current_level_num = 0
	global_scores = 0
	dragon_health = PLAYER_MAX_HEALTH
	dragon_lives = START_LIVES


func go_to_next_level() -> void:
	current_level_num += 1
	if current_level_num > level_paths.size():
		go_to_win_screen()
		return
	
	var next_level_index: int = current_level_num-1
	var level_path: String = level_paths[next_level_index]
	get_tree().change_scene_to_file(level_path)


func go_to_win_screen() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
