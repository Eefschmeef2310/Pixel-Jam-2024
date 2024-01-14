extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetEntryData(position : int, name : String, score : int):
	$Columns/Position.text = str(position)
	$Columns/Username.text = name 
	$Columns/Score.text = str(score)

func SetLocalEntry():
	var newSettings = $Columns/Username.label_settings.duplicate()
	newSettings.font_color = Color.GOLDENROD
	$Columns/Username.label_settings = newSettings
	$Columns/Position.label_settings = newSettings
	$Columns/Score.label_settings = newSettings
	
