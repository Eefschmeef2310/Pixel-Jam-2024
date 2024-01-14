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
var generation_types: Array[String] = [
	"generate_2x2"
]
var orders: Array = []
var max_orders = 3

var grid_node

signal orders_updated()

func _ready():
	#Initialise player
	player.stream = order_complete
	add_child(player)

func _process(_delta):
	if Input.is_action_just_pressed("space"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func generate_2x2():
	if grid_node:
		var order
		while !order or !count_order_against_grid(order):
			order = Order.new()
			order.width = 2
			order.height = 2
			order.grid = [[0,0],[0,0]]
			order.grid[0][0] = fruit_resources.pick_random()
			order.grid[0][1] = fruit_resources.pick_random()
			order.grid[1][0] = fruit_resources.pick_random()
			order.grid[1][1] = fruit_resources.pick_random()
		
		order.type = "generate_2x2"
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
			dict[order.grid[w][h]] += 1
	for key in dict:
		if dict[key] > grid_node.fruit_counts[key]:
			return false
	return true

func complete_order(order: Order):
	for o in orders:
		if o == order:
			# complete order
			#TODO - Variable score amounts - E
			ScoreManager.score = ScoreManager.score+1
		
			player.play()
			
			orders.erase(order)
			orders_updated.emit()
			return
