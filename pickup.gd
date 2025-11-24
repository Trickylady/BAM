extends Area2D

enum Type{
	SPEED,
	SHIELD,
	EXTRA_BOMB,
	DESTROY_TILES,
	KILL_ENEMY,
	EXTRA_LIFE,
	EXTRA_HEALTH
}

const Textures: Dictionary = {
	Type.SPEED : preload("res://boost_speed.png"),
	Type.SHIELD : preload("res://boost_shield.png"),
	Type.EXTRA_BOMB : preload("res://boost_extrabomb.png"),
	Type.DESTROY_TILES : preload("res://boost_destroy_all_tiles.png"),
	Type.KILL_ENEMY : preload("res://boost_kill_one_enemy.png"),
	Type.EXTRA_LIFE : preload("res://boost_life.png"),
	Type.EXTRA_HEALTH : preload("res://boost_health.png")
	}
	
