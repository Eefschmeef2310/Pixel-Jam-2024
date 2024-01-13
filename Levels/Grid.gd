extends Node2D

@onready var selected : TextureButton = $HBoxContainer/VBoxContainer/HBoxContainer/TextureButton

func _ready():
	selected.grab_focus()
