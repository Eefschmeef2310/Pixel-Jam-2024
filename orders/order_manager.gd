extends Node

var fruit_resources: Array[Fruit] = [
	preload("res://fruits/resources/apple.tres"),
	preload("res://fruits/resources/banana.tres"),
	preload("res://fruits/resources/grape.tres"),
	preload("res://fruits/resources/melon.tres"),
	preload("res://fruits/resources/orange.tres"),
	preload("res://fruits/resources/squid.tres"),
	preload("res://fruits/resources/straw.tres")
]
var orders: Array = []

signal orders_updated()

func generate_2x2():
	var order = Order.new()
	order.width = 2
	order.height = 2
	order.grid = [[0,0],[0,0]]
	order.grid[0][0] = fruit_resources.pick_random()
	order.grid[0][1] = fruit_resources.pick_random()
	order.grid[1][0] = fruit_resources.pick_random()
	order.grid[1][1] = fruit_resources.pick_random()
	
	orders.append(order)
	orders_updated.emit()

func complete_order(order: Order):
	for o in orders:
		if o == order:
			# complete order
			orders.erase(order)
			orders_updated.emit()
			return
