@tool
extends Area2D
class_name PickUp

enum Type{
	CRYSTAL,
	POT_OF_GOLD,
	SPEED,
	SHIELD,
	EXTRA_BOMB,
	DESTROY_TILES,
	KILL_ENEMY,
	EXTRA_LIFE,
	EXTRA_HEALTH
}

const Textures: Dictionary = {
	Type.CRYSTAL: preload("res://graphics/boosts/crystal.png"),
	Type.POT_OF_GOLD: preload("res://graphics/boosts/pot_of_gold.png"),
	Type.SPEED: preload("res://graphics/boosts/boost_speed.png"),
	Type.SHIELD: preload("res://graphics/boosts/boost_shield.png"),
	Type.EXTRA_BOMB: preload("res://graphics/boosts/boost_extrabomb.png"),
	Type.DESTROY_TILES: preload("res://graphics/boosts/boost_destroy_all_tiles.png"),
	Type.KILL_ENEMY: preload("res://graphics/boosts/boost_kill_one_enemy.png"),
	Type.EXTRA_LIFE: preload("res://graphics/boosts/boost_life.png"),
	Type.EXTRA_HEALTH: preload("res://graphics/boosts/boost_health.png")
}


@export var type: Type = Type.CRYSTAL: set = set_type
@export var points: int = 100

signal collected


var collision_shape: CollisionShape2D
var sprite: Sprite2D
var sfx: AudioStreamPlayer
var particles: CPUParticles2D


func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D: collision_shape = child
		if child is Sprite2D: sprite = child
		if child is AudioStreamPlayer: sfx = child
		if child is CPUParticles2D: particles = child
	
	body_entered.connect(_on_body_entered)
	if type == Type.CRYSTAL:
		Mng.level.crystal_list.append(self)
		collected.connect(Mng.level._on_crystal_collected.bind(self))


func set_type(value: Type) -> void:
	type = value
	if sprite: sprite.texture = Textures[type]


func pick_up() -> void:
	if sprite: sprite.hide()
	if collision_shape: collision_shape.set_deferred(&"disabled", true)
	if particles: particles.emitting = true
	if sfx: sfx.play()
	collected.emit()


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.pick_up(self)
		pick_up()
