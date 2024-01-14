extends Resource
class_name Order

var name: String = "Smoothie"
var type: String = "generate_2x2"
var grid: Array
var width: int
var height: int

#TODO - I'm assuming that this can run a timer
var timer = Timer.new()
var countdown: float = 3.;

func _ready():
	timer.start(countdown)

func _process(_delta):
	print(timer.time_left)
