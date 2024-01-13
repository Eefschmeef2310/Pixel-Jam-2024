extends Node2D

var fruit_handle_scene = preload("res://fruits/fruit_handle.tscn")
var fruit_resources: Array[Fruit] = [
	preload("res://fruits/resources/apple.tres"),
	preload("res://fruits/resources/banana.tres"),
	preload("res://fruits/resources/grape.tres"),
	preload("res://fruits/resources/melon.tres"),
	preload("res://fruits/resources/orange.tres"),
	preload("res://fruits/resources/squid.tres"),
	preload("res://fruits/resources/straw.tres")
]

var grid: = []
var width: int = 7
var height: int = 7
var cell_size: float = 50

signal grid_changed()

func _ready():
	#position.x = cell_size/2
	#position.y = cell_size/2
	
	for w in width:
		grid.append([])
		for h in height:
			grid[w].append(null)
	
	fill_grid()

func _process(_delta):
	if Input.is_action_just_pressed("space"):
		fill_grid()

func fill_grid():
	# Move all fruits down to fill empty space
	
	#Generate new fruits
	for w in width:
		for h in height:
			if !grid[w][h] or is_instance_valid(!grid[w][h]):
				var fruit = fruit_handle_scene.instantiate()
				add_child(fruit)
				grid[w][h] = fruit
				fruit.set_fruit(fruit_resources.pick_random())
				fruit.force_move()
				print(fruit.fruit.name)
	
	grid_changed.emit()
	
func get_fruit_coords(fruit) -> Vector2i:
	for w in width:
		for h in height:
			if grid[w][h] == fruit:
				return Vector2i(w, h)
	return Vector2i(-1, -1)

func move_line_x(y, amount):
	if amount == 0:
		pass
	
	# copy line into new array
	var arr = []
	for w in width:
		arr.append(grid[w][y])
	
	for w in width:
		var new_x = w + amount
		while new_x < 0:
			new_x += width
		while new_x >= width:
			new_x -= width
		grid[new_x][y] = arr[w]
	
	grid_changed.emit()

func move_line_y(x, amount):
	if amount == 0:
		pass
	
	# copy line into new array
	var arr = []
	for h in height:
		arr.append(grid[x][h])
	
	for h in height:
		var new_y = h + amount
		if new_y < 0:
			new_y += height
		elif new_y >= height:
			new_y -= height
		grid[x][new_y] = arr[h]
	
	grid_changed.emit()

func move_fruit_x(fruit, amount):
	if !fruit or amount == 0:
		return
		
	# fc means fruit_coords
	var fc = get_fruit_coords(fruit)
	if fc.x == -1 or fc.x + amount < 0 or fc.x + amount >= width:
		return
	
	var n = 0
	while n != amount:
		grid[fc.x + n][fc.y] = grid[fc.x + n + sign(amount)][fc.y]
		n += sign(amount)
	grid[fc.x + n][fc.y] = fruit
		
	grid_changed.emit()

func move_fruit_y(fruit, amount):
	if !fruit or amount == 0:
		return
		
	# fc means fruit_coords
	var fc = get_fruit_coords(fruit)
	if fc.y == -1 or fc.y + amount < 0 or fc.y + amount >= height:
		return
	
	var n = 0
	while n != amount:
		grid[fc.x][fc.y + n] = grid[fc.x][fc.y + n + sign(amount)]
		n += sign(amount)
	grid[fc.x][fc.y + n] = fruit
	
	grid_changed.emit()
