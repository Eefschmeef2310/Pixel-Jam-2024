extends Node2D

const ORDER_DISPLAY = preload("res://orders/order_display.tscn")
var ticket_slots = []
var separation = 80

func _ready():
	ticket_slots.resize(OrderManager.max_orders)
	ticket_slots.fill(null)
	OrderManager.orders_updated.connect(_on_orders_updated)
	_on_orders_updated()

func _on_orders_updated():
	print("Updating orders.")
	
	# At this point, orders should have already been deleted.
	# Remove completed tickets from the ticket slot array.
	for n in ticket_slots.size():
		if ticket_slots[n] != null and !ticket_slots[n].order in OrderManager.orders:
			# solve ticket
			ticket_slots[n].complete_ticket()
			ticket_slots[n] = null

	for order in OrderManager.orders:
		# Check that there isn't already a ticket for this order
		# If there isn't, spawn a new ticket for it in an empty slot.
		if get_ticket_index(order) == -1:
			var slot = get_first_empty_slot()
			if slot != -1:
				var order_display = ORDER_DISPLAY.instantiate()
				add_child(order_display)
				
				order_display.set_order(order)
				order_display.position.x += (slot * separation)
				
				ticket_slots[slot] = order_display

func get_ticket_index(order):
	for n in ticket_slots.size():
		if ticket_slots[n] != null and ticket_slots[n].order == order:
			return n
	return -1

func get_first_empty_slot():
	for n in ticket_slots.size():
		if ticket_slots[n] == null:
			return n
	return -1
