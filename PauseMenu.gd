extends Control

func _process(delta):
	hide()
	testEsc()

# Called when the node enters the scene tree for the first time.
func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	show()
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_exit_pressed() -> void:
	get_tree().quit()
