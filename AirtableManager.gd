extends HTTPRequest

var headers = ["Content-Type: application/json", "Authorization: Bearer patmff0RoQNsaXAu4.c266daf41f901816c2993c075c457a3fee210eeb7d4cf0b2593c575261633776"]
var usernamePickerScene = "res://Levels/usernamePicker.tscn"
var menuScene = "res://Levels/main_game.tscn"

var saveRes : SaveData
var savePath : String = "user://savegame.tres"
var acceptingNewID : bool = false
var waitingForResponse : bool = false

var debugNewSave = false #set to true to force a new username to be picked

signal response(string)
signal noUserSet

# Called when the node enters the scene tree for the first time.
func _ready():
	request_completed.connect(_on_request_completed)
	if (FileAccess.file_exists(savePath)||debugNewSave):
		Load()
	else:
		#create a new save file
		saveRes = SaveData.new()
		noUserSet.emit()
		get_tree().change_scene_to_file(usernamePickerScene)
	#load save data - if no save data then make user pick name
	
	pass # Replace with function body.

func SetSaveData(userID : String, username : String): #connect with signal(?) for when username has been set or changed
	saveRes.userID = userID
	saveRes.username = username

func CheckUsername(username) -> bool: #returns true if it is a new username
	var url = "https://api.airtable.com/v0/appFZUpd22afr8fEJ/Highscores?fields%5B%5D=Username&filterByFormula=%7BUsername%7D+%3D+'"+username+"'&maxRecords=1&pageSize=1"
	var error = request(url, headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the username lookup request.")
		print("An error occurred in the username lookup request.")
	else:
		print("username lookup seemed to work...")
	waitingForResponse = true
	#while(waitingForResponse):
		##print("waiting for the suername lookup")
		#pass
	
	
	return false

func NewUser(username) -> String:
	#does not check usernaem (use CheckUsername())
	#this function just makes a blank user record and returns the record id
	print("updating a record")
	var url = "https://api.airtable.com/v0/appFZUpd22afr8fEJ/Highscores"
	var data = {"records": [
	{
	  "fields": {
		"Username" : String(username),
		"Highscore": 0, 
		"Games Played": 0,
		"Total seconds played": 0.0
	  }
	}]}
	var error = request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	if error != OK:
		push_error("An error occurred in the new user request.")
		print("An error occurred in the new user request.")
	else:
		print("new user request Sent! awaiting response...")
	
	acceptingNewID = true
	
	while saveRes.userID == "":
		print("waiting for user id")
	
	acceptingNewID = false
	return saveRes.userID


#func PullAndUpload():
	##var distance = GameManager.tank_position.x
	##var gears = GameManager.gears
	##var upgradeState = UpgradeManager.upgrade_state()
	##var score = ScoreManager.calculateScore()
	##var enimiesKilled = ScoreManager.enemiesKilled
	##var progressScore = ScoreManager.progress_score
	##var endReached = GameManager.end_reached
	##UploadRun(score, distance, gears, upgradeState, progressScore, enimiesKilled, endReached)
	#pass

func UploadRun(userID : String, username : String, highscore : int, gamesPlayed : int, playtime : float):
	print("updating a record")
	var url = "https://api.airtable.com/v0/appFZUpd22afr8fEJ/Highscores/" + userID
	var data = {"records": [
	{
	  "fields": {
		"Username" : String(username),
		"Highscore": int(highscore), 
		"Games Played": int(gamesPlayed),
		"Total seconds played": float(playtime)
	  }
	}]}
	var error = request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		print("HTTP Error D=")
	else:
		print("Run Data Sent!")
	return true

func Save():
	ResourceSaver.save(SaveData, savePath)
	
func Load():
	saveRes = ResourceLoader.load(savePath)

#func _on_nyan_debug_cmd_upload(username, score, version):
	#Upload(username, score, version)
	#pass # Replace with function body.

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(JSON.stringify(json))
	response.emit(JSON.stringify(json))
	if(waitingForResponse):
		#print("amount of records: " + str(json.records.size()))
		if(json.records.size() > 0):
			print("username is NOT new")
		waitingForResponse = false
		pass
	#print(str(json[1]))
