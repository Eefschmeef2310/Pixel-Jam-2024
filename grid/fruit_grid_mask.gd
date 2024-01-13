extends TextureRect

func _ready():
	size.x = $FruitGrid.width * $FruitGrid.cell_size
	size.y = $FruitGrid.height * $FruitGrid.cell_size
