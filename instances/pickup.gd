extends Area2D
class_name PickUp

enum Type{
	CRYSTAL,
	POT_OF_GOLD,
	SPEED,
	SHIELD,
	EXTRA_BOMB,
	BIGGER_EXPLOSION,
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
	Type.BIGGER_EXPLOSION: preload("res://graphics/boosts/boost_extrabomb.png"),
	Type.DESTROY_TILES: preload("res://graphics/boosts/boost_destroy_all_tiles.png"),
	Type.KILL_ENEMY: preload("res://graphics/boosts/boost_kill_one_enemy.png"),
	Type.EXTRA_LIFE: preload("res://graphics/boosts/boost_life.png"),
	Type.EXTRA_HEALTH: preload("res://graphics/boosts/boost_health.png"),
}

const Labels: Dictionary = {
	Type.CRYSTAL: "",
	Type.POT_OF_GOLD: "Pot Of Gold",
	Type.SPEED: "Speed",
	Type.SHIELD: "Shield",
	Type.EXTRA_BOMB: "Extra Bomb",
	Type.BIGGER_EXPLOSION: "Bigger Explosion",
	Type.DESTROY_TILES: "Destroy Tiles",
	Type.KILL_ENEMY: "Kill Enemy",
	Type.EXTRA_LIFE: "Extra Life",
	Type.EXTRA_HEALTH: "Extra Health",
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
	add_label()
	collected.emit()


func add_label() -> void:
	var label_text: String = Labels[type]
	if not label_text: return
	var popup_label: PopupLabel = preload("res://instances/popup_label.tscn").instantiate()
	popup_label.text = label_text
	Mng.level.gameoverlay.add_child(popup_label)
	popup_label.global_position = global_position


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.pick_up(self)
		pick_up()
