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

var grid_node

signal orders_updated()

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
		
		orders.append(order)
		orders_updated.emit()

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
			orders.erase(order)
			orders_updated.emit()
			return
