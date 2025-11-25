extends Control


var master_bus := AudioServer.get_bus_index("Master")
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")


func _ready() -> void:
	%SliderMaster.value = AudioServer.get_bus_volume_linear(master_bus)
	%SliderMusic.value = AudioServer.get_bus_volume_linear(music_bus)
	%SliderSFX.value = AudioServer.get_bus_volume_linear(sfx_bus)


func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
func _on_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
func _on_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
