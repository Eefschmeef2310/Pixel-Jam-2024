extends Node2D

@onready var game_over_screen : PackedScene = preload("res://Levels/game_over_screen.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		game_over()
		
func game_over():
	get_tree().root.add_child(game_over_screen.instantiate())
