extends PanelContainer

var order: Order
@onready var grid = $H/V/GridContainer

func _ready():
	pass

func set_order(o: Order):
	for child in grid.get_children():
		child.queue_free()
	order = o
	grid.columns = order.width
	for y in order.height:
		for x in order.width:
			var rect = TextureRect.new()
			rect.texture = order.grid[x][y].texture
			grid.add_child(rect)
		
