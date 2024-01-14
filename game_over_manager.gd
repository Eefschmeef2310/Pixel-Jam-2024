extends Node

@onready var game_over_screen : PackedScene = preload("res://Levels/game_over_screen.tscn")

func game_over():
	get_tree().root.add_child(game_over_screen.instantiate())
