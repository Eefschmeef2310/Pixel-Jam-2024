extends GridContainer

@export var width: int
@export var height: int

@onready var ingredient : PackedScene = preload("res://Ingredients/Ingredient.tscn")

func _ready():
	columns = width
	for i in width * height:
		add_child(ingredient.instantiate())
	
	get_child(0).grab_focus()
