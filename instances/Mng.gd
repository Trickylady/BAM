extends Node

const TILE_SIZE: Vector2 = Vector2(70, 70)

#region Game Modifiers
# level
const LEVEL_TIME: float = 120.0 # seconds
const RED_MODE_DURATION: float = 30.0 # seconds

# general points
const GROUND_TILE_POINTS: int = 10
const ENEMY_KILLED_POINTS: int = 250
const RED_MODE_POINTS_MULTIPLIER: float = 2.5

# player
const BOOST_SPEED_MULTIPLIER: float = 1.8
const PLAYER_MAX_HEALTH: float = 6.0
const START_LIVES: int = 3
const START_MAX_BOMBS: int = 5
const START_EXPLOSION_SIZE: int = 1 # tiles
const RESPAWN_TIME_AFTER_DEATH: float = 2.5 # seconds
#endregion


#region Game Stats
var global_scores: int = 0
var current_scores: int = 0:
	set(value):
		current_scores = value
		scores_updated.emit()
signal scores_updated

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
#endregion


#region Levels management
const LEVELS_FOLDER: String = "res://levels/"
var level_filenames: Array[String] = []
var levels_tot:
	get: return level_filenames.size()
var level: Level:
	set(value):
		level = value
		level_ready.emit()

signal level_ready
#endregion



func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://theme/cursor.png"))
	level_filenames = _get_all_levels()


func _get_all_levels() -> Array[String]:
	var found: Array[String] = []
	for filename: String in DirAccess.get_files_at("res://levels/"):
		if filename.contains("test"):
			continue
		if filename.get_extension() == "tscn":
			found.append(filename)
	return found


func go_to_main_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func start_game() -> void:
	reset_stats()
	go_to_next_level()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func start_test_game() -> void:
	reset_stats()
	get_tree().change_scene_to_file("res://levels/level_test.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func reset_stats() -> void:
	current_level_num = 0
	global_scores = 0
	current_scores = 0
	dragon_health = PLAYER_MAX_HEALTH
	dragon_lives = START_LIVES


func go_to_next_level() -> void:
	current_level_num += 1
	global_scores += current_scores
	current_scores = 0
	if current_level_num > levels_tot:
		go_to_main_menu()
		return
	
	var next_level_index: int = current_level_num - 1
	var level_path: String = LEVELS_FOLDER.path_join(level_filenames[next_level_index])
	get_tree().change_scene_to_file(level_path)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
