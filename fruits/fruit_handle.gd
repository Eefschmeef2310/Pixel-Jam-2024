extends Node2D

@onready var sprite_2d = $Sprite2D
@export var fruit: Fruit

func _process(delta):
	var parent = get_parent()
	var grid_coords: Vector2i = parent.get_fruit_coords(self)
	if grid_coords.x != -1:
		position = lerp(position, Vector2(grid_coords * parent.cell_size), 10*delta)

func set_fruit(f: Fruit):
	fruit = f
	sprite_2d.texture = f.texture
