extends Node2D

const ORDER_DISPLAY = preload("res://orders/order_display.tscn")
var ticket_slots = []
var separation = -90

func _ready():
	ticket_slots.resize(OrderManager.max_orders)
	ticket_slots.fill(null)
	OrderManager.orders_updated.connect(_on_orders_updated)
	_on_orders_updated()

func _process(_delta):
	pass

func _on_orders_updated():
	print("Updating orders.")
	
	# At this point, orders should have already been deleted.
	# Remove completed tickets from the ticket slot array.
	for n in ticket_slots.size():
		if ticket_slots[n] != null and !ticket_slots[n].order in OrderManager.orders:
			# solve ticket
			ticket_slots[n].complete_ticket()
			ticket_slots[n] = null

	# Erase null entries
	for n in ticket_slots.size():
		ticket_slots.erase(null)

	# Add time to each order if there is a last completed score saved
	if OrderManager.last_completed_order_score != 0:
		for ticket in ticket_slots:
			ticket.add_time(OrderManager.last_completed_order_score)
		OrderManager.last_completed_order_score = 0
	
	# Check that there isn't already a ticket for each order
	# If there isn't, spawn a new ticket for it in an empty slot.
	for order in OrderManager.orders:
		if get_ticket_index(order) == -1:
			var slot = ticket_slots.size()
			var order_display = ORDER_DISPLAY.instantiate()
			add_child(order_display)
			
			order_display.set_order(order)
			order_display.position.x += (slot * separation)
			ticket_slots.append(order_display)
	
	# Move orders to their proper positions
	ticket_slots.sort_custom(sort_tickets_by_time_left)
	for n in ticket_slots.size():
		if ticket_slots[n] != null:
			ticket_slots[n].target_position = Vector2(n * separation, 0)
	print(ticket_slots)

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

func sort_tickets_by_time_left(a, b):
	if a == null or b == null:
		return true
	if a.timer.time_left < b.timer.time_left:
		return true
	return false
