extends Control

@onready var sounds_manager = $"/root/GlobalSoundsManager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sounds_manager.sfx_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	sounds_manager.sfx_menu_music_stop()
	sounds_manager.sfx_background()
	get_tree().change_scene_to_file("res://GameplayScene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
