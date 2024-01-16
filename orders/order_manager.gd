extends Node

var order_complete : AudioStream = preload("res://Audio/Good.mp3")
var player : AudioStreamPlayer = AudioStreamPlayer.new()

var fruit_resources: Array[Fruit] = [
	preload("res://fruits/resources/apple.tres"),
	preload("res://fruits/resources/banana.tres"),
	preload("res://fruits/resources/grape.tres"),
	preload("res://fruits/resources/melon.tres"),
	preload("res://fruits/resources/orange.tres"),
	preload("res://fruits/resources/straw.tres")
]
var orders: Array = []
var max_orders = 3

@export var order_countdown_curve: Curve
@export var order_arrival_curve: Curve

var difficulty_timer: float = 0
var max_difficulty_time: float = 360
var hard_order_threshold: float = 200
var timer_updating: bool = true

var grid_node

var last_completed_order_score = 0

signal orders_updated()

func _ready():
	#Initialise player
	player.stream = order_complete
	player.bus = "sfx"
	player.max_polyphony = 99
	add_child(player)
	
	orders_updated.connect(_on_orders_updated)
	
	reset()

func _process(delta):
	if timer_updating:
		difficulty_timer += delta
	
	if Input.is_action_just_pressed("space"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func reset():
	orders.clear()
	difficulty_timer = 0.0

func generate_2x2():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 2
			order.height = 2
			order.grid = [[null,null],[null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_2x2"
		order.countdown = 40 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 4
		orders.append(order)
		orders_updated.emit()

func generate_3x2():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 3
			order.height = 2
			order.grid = [[null,null],[null,null],[null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_2x2"
		order.countdown = 60 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 6
		orders.append(order)
		orders_updated.emit()

func generate_2x3():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 2
			order.height = 3
			order.grid = [[null,null,null],[null,null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_2x2"
		order.countdown = 60 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 6
		orders.append(order)
		orders_updated.emit()

func generate_3x3_cross():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 3
			order.height = 3
			order.grid = [[null,null,null],[null,null,null],[null,null,null]]
			order.grid[1][0] = fruit_resources.pick_random()
			order.grid[0][1] = fruit_resources.pick_random()
			order.grid[1][1] = fruit_resources.pick_random()
			order.grid[2][1] = fruit_resources.pick_random()
			order.grid[1][2] = fruit_resources.pick_random()
		
		order.type = "generate_3x3"
		order.countdown = 75 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 9
		orders.append(order)
		orders_updated.emit()

func generate_3x3():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 3
			order.height = 3
			order.grid = [[null,null,null],[null,null,null],[null,null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_3x3"
		order.countdown = 75 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 9
		orders.append(order)
		orders_updated.emit()

func generate_2x4():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 2
			order.height = 4
			order.grid = [[null,null,null,null],[null,null,null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_2x4"
		order.countdown = 75 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 8
		orders.append(order)
		orders_updated.emit()

func generate_4x2():
	if grid_node and orders.size() < max_orders:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 4
			order.height = 2
			order.grid = [[null,null],[null,null],[null,null],[null,null]]
			for x in order.width:
				for y in order.height:
					order.grid[x][y] = fruit_resources.pick_random()
		
		order.type = "generate_4x2"
		order.countdown = 75 * order_countdown_curve.sample(get_difficulty_curve_x())
		order.score = 9
		orders.append(order)
		orders_updated.emit()

func validate_current_orders():
	for order in orders:
		if !count_order_against_grid(order):
			call(order.type)
			orders.erase(order)
			orders_updated.emit()
			return

func count_order_against_grid(order: Order):
	var dict: Dictionary = {}
	for fruit in fruit_resources:
		dict[fruit] = 0
	for w in order.width:
		for h in order.height:
			print(order.grid[w][h])
			if order.grid[w][h] != null:
				dict[order.grid[w][h]] += 1
	for key in dict:
		if dict[key] > grid_node.fruit_counts[key]:
			return false
	return true
		

func _on_orders_updated():
	for order in orders:
		if !count_order_against_grid(order):
			# Order is currently impossible. Get rid of it.
			ScoreManager.score -= order.score
			complete_order(order)
			
			call(order.type)

func check_all_orders():
	if grid_node:
		grid_node.check_all_orders()

func complete_order(order: Order):
	for o in orders:
		if o == order:
			# complete order
			#TODO - Variable score amounts - E
			ScoreManager.score = ScoreManager.score + order.score
			last_completed_order_score = order.score
		
			player.play()
			
			orders.erase(order)
			orders_updated.emit()
			return

func get_order_index(order):
	for n in orders.size():
		if orders[n] == order:
			return n
	return -1

func get_difficulty_curve_x():
	return difficulty_timer / max_difficulty_time
