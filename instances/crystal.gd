extends Area2D

class_name Crystal

signal collected


func _ready() -> void:
	Mng.level.crystal_list.append(self)
	collected.connect(Mng.level._on_crystal_collected.bind(self))


func pick_up() -> void:
	$crystalpickup.play()
	$crystalsprite.hide()
	$Collision.set_deferred(&"disabled", true)
	collected.emit()


func _on_crystalpickup_finished() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pick_up_crystal()
		pick_up()
