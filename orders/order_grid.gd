extends HBoxContainer

const ORDER_DISPLAY = preload("res://orders/order_display.tscn")

func _ready():
	OrderManager.orders_updated.connect(_on_orders_updated)
	_on_orders_updated()

func _on_orders_updated():
	#print("Updating orders.")
	for child in get_children():
		child.queue_free()
	
	for order in OrderManager.orders:
		#print(order.name)
		var order_display = ORDER_DISPLAY.instantiate()
		add_child(order_display)
		order_display.set_order(order)
