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

const LEVELS_FOLDER: String = "res://levels/"
var level_filenames: Array[String] = []
var level: Level:
	set(value):
		level = value
		level_ready.emit()

signal level_ready



func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://theme/cursor.png"))
	level_filenames = _get_all_levels()


func _get_all_levels() -> Array[String]:
	var found: Array[String] = []
	for filename: String in DirAccess.get_files_at("res://levels/"):
		if filename.get_extension() == "tscn":
			found.append(filename)
	return found


func go_to_main_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://menu.tscn")


func start_game() -> void:
	reset_stats()
	go_to_next_level()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func reset_stats() -> void:
	current_level_num = 0
	global_scores = 0
	dragon_health = PLAYER_MAX_HEALTH
	dragon_lives = START_LIVES


func go_to_next_level() -> void:
	current_level_num += 1
	if current_level_num > level_filenames.size():
		go_to_win_screen()
		return
	
	var next_level_index: int = current_level_num - 1
	var level_path: String = LEVELS_FOLDER.path_join(level_filenames[next_level_index])
	get_tree().change_scene_to_file(level_path)


func go_to_win_screen() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/winscreen.tscn")


func go_to_gameover_screen() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
