extends Control

var options : PackedScene = preload("res://Levels/Options.tscn")

func _ready():
	get_tree().paused = true
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_continue_button_button_down()

func _on_menu_button_button_down():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

func _on_continue_button_button_down():
	get_tree().paused = false
	queue_free()

func _on_options_button_button_down():
	get_tree().root.add_child(options.instantiate())
