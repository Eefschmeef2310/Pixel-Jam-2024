extends Control

@onready var error_text = $VBoxContainer/ErrorText
@onready var username_feild = $VBoxContainer/UsernameFeild
@onready var submit_button = $VBoxContainer/SubmitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_submit_button_pressed():
	#do a list records call filtered by the provided username, if any records are returned then make the user try again
	#otherwise create the record 
	var result = AirtableManager.CheckUsername(username_feild.text)
	if result == null:
		print("username check result is NULL!!!")
	elif result == false:
		error_text.text = "Username already taken! please pick a new name"
	else:
		AirtableManager.NewUser(username_feild.text)
