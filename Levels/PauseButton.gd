extends Button

@onready var pause_screen = preload("res://Levels/pause.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_button_down()

func _on_button_down():
	get_tree().root.add_child(pause_screen.instantiate())
