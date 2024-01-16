extends Node2D

var fruit_handle_scene = preload("res://fruits/fruit_handle.tscn")
var matched_particles = preload("res://grid/matched_particles.tscn")

var grid: = []
var width: int = 5
var height: int = 5
var cell_size: float = 40
var fruit_counts: Dictionary

signal grid_changed()

func _ready():
	position.x += cell_size/2
	position.y += cell_size/2
	OrderManager.grid_node = self
	
	for w in width:
		grid.append([])
		for h in height:
			grid[w].append(null)
	
	fill_grid(true)

#func _process(_delta):
	#if Input.is_action_just_pressed("space"):
		#fill_grid()

func fill_grid(random: bool = true):
	# Move all fruits down to fill empty space
	
	# Generate new fruits
	for w in width:
		for h in height:
			if !grid[w][h] or is_instance_valid(!grid[w][h]):
				var fruit = fruit_handle_scene.instantiate()
				add_child(fruit)
				if random:
					fruit.set_fruit(OrderManager.fruit_resources.pick_random())
				else:
					var new_fruit = get_smallest_fruit_count()
					fruit.set_fruit(new_fruit)
					fruit_counts[new_fruit] += 1
				fruit.position = Vector2(0, 215)
				grid[w][h] = fruit
				#print(fruit.fruit.name)
	
	# count fruits
	count_fruits()
	#OrderManager.validate_current_orders()
	
	grid_changed.emit()

func count_fruits():
	var dict: Dictionary = {}
	for fruit in OrderManager.fruit_resources:
		dict[fruit] = 0
	for w in width:
		for h in height:
			dict[grid[w][h].fruit] += 1
	fruit_counts = dict

func get_smallest_fruit_count():
	var smallest_fruit
	var smallest_count = 9999
	for fruit in fruit_counts:
		if fruit_counts[fruit] < smallest_count:
			smallest_count = fruit_counts[fruit]
			smallest_fruit = fruit
	return smallest_fruit

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

func check_all_orders():
	for order in OrderManager.orders:
		check_order(order)

func check_order(order: Order):
	for w in width - order.width + 1:
		for h in height - order.height + 1:
			#print(str(w) + ", " + str(h))
			if check_order_at_cell(order, w, h):
				print("holy shit")
				remove_order_at_cell(order, w, h)
				OrderManager.complete_order(order)
				return
			#else:
				#print("damn")

func check_order_at_cell(order: Order, w: int, h: int):
	for x in order.width:
		for y in order.height:
			if order.grid[x][y] != null and grid[w+x][h+y].fruit != order.grid[x][y]:
				return false
	return true

func remove_order_at_cell(order: Order, w: int, h: int):
	for x in order.width:
		for y in order.height:
			if grid[w+x][h+y] != null:
				var particles: GPUParticles2D = matched_particles.instantiate()
				get_parent().add_child(particles)
				particles.global_position = grid[w+x][h+y].global_position
				particles.emitting = true
				
				grid[w+x][h+y].queue_free()
				grid[w+x][h+y] = null
	fill_grid(false)
