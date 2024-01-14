extends Node2D

@onready var sprite_2d = $Sprite2D
@export var fruit: Fruit

@onready var cell_change_stream_player = $CellChangeStreamPlayer

var is_clicked = false
var starting_mouse_coords: Vector2

var starting_pos: Vector2
var movement_direction: Vector2
var cell_offset: Vector2

var controlling_handles: Array = []
var temp_handles: Array = []

var last_amount: int

func _ready():
	pass

func _process(delta):
	if is_clicked:
		var mouse_pos = get_viewport().get_mouse_position()
		var parent = get_parent()
		if movement_direction == Vector2(0, 0):
			if mouse_pos.x <= starting_mouse_coords.x - 10 \
			or mouse_pos.x >= starting_mouse_coords.x + 10:
				var self_coords = parent.get_fruit_coords(self)
				for w in parent.width:
					var other = parent.grid[w][self_coords.y]
					other.starting_pos = Vector2(w, self_coords.y) * parent.cell_size + parent.position
					other.movement_direction.x = 1
					other.cell_offset.x = w - self_coords.x
					
					var mirror = parent.fruit_handle_scene.instantiate()
					mirror.movement_direction.x = 1
					mirror.cell_offset.x = w - self_coords.x + parent.width
					mirror.starting_pos = other.starting_pos + Vector2(parent.width, 0) * parent.cell_size
					parent.add_child(mirror)
					temp_handles.append(mirror)
					mirror.set_fruit(other.fruit)
					mirror.force_move()
					
					mirror = parent.fruit_handle_scene.instantiate()
					mirror.movement_direction.x = 1
					mirror.cell_offset.x = w - self_coords.x - parent.width
					mirror.starting_pos = other.starting_pos - Vector2(parent.width, 0) * parent.cell_size
					parent.add_child(mirror)
					temp_handles.append(mirror)
					mirror.set_fruit(other.fruit)
					mirror.force_move()

			elif mouse_pos.y <= starting_mouse_coords.y - 10 \
			or mouse_pos.y >= starting_mouse_coords.y + 10:
				var self_coords = parent.get_fruit_coords(self)
				for h in parent.height:
					var other = parent.grid[self_coords.x][h]
					other.starting_pos = Vector2(self_coords.x, h) * parent.cell_size + parent.position
					other.movement_direction.y = 1
					other.cell_offset.y = h - self_coords.y
					
					var mirror = parent.fruit_handle_scene.instantiate()
					mirror.movement_direction.y = 1
					mirror.cell_offset.y = h - self_coords.y + parent.height
					mirror.starting_pos = other.starting_pos + Vector2(0, parent.height) * parent.cell_size
					parent.add_child(mirror)
					temp_handles.append(mirror)
					mirror.set_fruit(other.fruit)
					mirror.force_move()
					
					mirror = parent.fruit_handle_scene.instantiate()
					mirror.movement_direction.y = 1
					mirror.cell_offset.y = h - self_coords.y - parent.height
					mirror.starting_pos = other.starting_pos - Vector2(0, parent.height) * parent.cell_size
					parent.add_child(mirror)
					temp_handles.append(mirror)
					mirror.set_fruit(other.fruit)
					mirror.force_move()

		if Input.is_action_just_released("click"):
			_on_click_released()
			

	if movement_direction != Vector2(0, 0):
		var parent = get_parent()
		var pos = get_viewport().get_mouse_position() + (cell_offset * parent.cell_size)
		if movement_direction.x == 0:
			pos.x = starting_pos.x
			if is_clicked:
				var difference = position.y - (starting_pos.y - parent.position.y)
				difference += parent.cell_size/2
				var amount = floor(difference/parent.cell_size)
				if amount != last_amount:
					cell_change_stream_player.play()
					last_amount = amount
		if movement_direction.y == 0:
			pos.y = starting_pos.y
			if is_clicked:
				var difference = position.x - (starting_pos.x - parent.position.x)
				difference += parent.cell_size/2
				var amount = floor(difference/parent.cell_size)
				if amount != last_amount:
					cell_change_stream_player.play()
					last_amount = amount
		global_position = pos
		global_position.x = clamp(global_position.x, \
			starting_pos.x - (parent.width * parent.cell_size), \
			starting_pos.x + (parent.width * parent.cell_size))
		global_position.y = clamp(global_position.y, \
			starting_pos.y - (parent.height * parent.cell_size), \
			starting_pos.y + (parent.height * parent.cell_size))
	
	else:
		move(delta)

func move(delta):
	var parent = get_parent()
	var grid_coords: Vector2i = parent.get_fruit_coords(self)
	if grid_coords.x != -1:
		position = lerp(position, Vector2(grid_coords * parent.cell_size), 10*delta)

func force_move():
	var parent = get_parent()
	var grid_coords: Vector2i = parent.get_fruit_coords(self)
	if grid_coords.x != -1:
		position = Vector2(grid_coords * parent.cell_size)

func set_fruit(f: Fruit):
	fruit = f
	sprite_2d.texture = f.texture

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_on_click_pressed()
		else:
			_on_click_released()
	elif event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		queue_free()

func _on_click_pressed():
	#print("sheesh!")
	is_clicked = true
	last_amount = 0
	starting_mouse_coords = get_viewport().get_mouse_position()

func _on_click_released():
	#print("awwww...")
	var parent = get_parent()
	var amount = 0
	
	if movement_direction.x == 1:
		var self_coords = parent.get_fruit_coords(self)
		var difference = position.x - (starting_pos.x - parent.position.x)
		difference += parent.cell_size/2
		amount = floor(difference/parent.cell_size)
		
		for w in parent.width:
			var other = parent.grid[w][self_coords.y]
			if w + amount < 0:
				other.global_position.x += parent.width * parent.cell_size
			elif w + amount >= parent.width:
				other.global_position.x -= parent.width * parent.cell_size
			other.movement_direction = Vector2(0, 0)
			other.cell_offset = Vector2(0, 0)
		
		parent.move_line_x(self_coords.y, amount)
		
	elif movement_direction.y == 1:
		var self_coords = parent.get_fruit_coords(self)
		var difference = position.y - (starting_pos.y - parent.position.y)
		difference += parent.cell_size/2
		amount = floor(difference/parent.cell_size)
		
		for h in parent.height:
			var other = parent.grid[self_coords.x][h]
			if h + amount < 0:
				other.global_position.y += parent.height * parent.cell_size
			elif h + amount >= parent.height:
				other.global_position.y -= parent.height * parent.cell_size
			other.movement_direction = Vector2(0, 0)
			other.cell_offset = Vector2(0, 0)
		
		parent.move_line_y(self_coords.x, amount)
	
	for child in temp_handles:
		child.hide()
		child.queue_free()
	temp_handles.clear()
	
	is_clicked = false
