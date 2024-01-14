extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_menu_button_button_down():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

func _on_continue_button_button_down():
	get_tree().paused = false
	queue_free()
