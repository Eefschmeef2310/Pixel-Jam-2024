extends Button

@onready var pause_screen = preload("res://Levels/pause.tscn")

func _on_button_down():
	get_tree().root.add_child(pause_screen.instantiate())
