extends Node

var save_path = "user://save_game.json"

var maze_height = 20
var maze_width = 20
var paused
var ded = false
var hint = false
var slider = 100
var master_vol = 100
var victory_vol = 100

var inverted = false
var separated_control = false
var invis = false
var anno_un = false #a litle reference for manga readers (it means unknown for those who don't know)
var ghost = false
var buddy = false
var key = false
var key_found = false
var moving = false
var move = false

var challenge : String = ""
var time : int
var size : Vector2 = Vector2(maze_height, maze_width)
var best : Dictionary = {
	"none" : {},
	"inverted" : {},
	"anno_un" : {},
	"moving" : {},
	"invisible" : {},
	"ghost" : {},
	"buddy" : {},
	"key" : {},
	"camera" : {}
}

func save_game():
	var _size_key = "%dx%d" % [maze_width, maze_height]
	var data = {
		"best": best,
		"hint": hint,
		"master_volume": master_vol,
		"victory_volume": victory_vol
	}
	
	var json_text = JSON.stringify(data)
	json_text = json_text.replace('"anno_un"', '"anno_un"/*a litle reference for manga readers (it means unknown for those who don\'t know) */')

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json_text)
	file.close()



func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		content = content.replace("/*a litle reference for manga readers (it means unknown for those who don\'t know) */", "")
		
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			best = result.get("best", {
				"none" : {},
				"inverted" : {},
				"anno_un" : {},
				"moving" : {},
				"invisible" : {},
				"ghost" : {},
				"buddy" : {},
				"key" : {},
				"camera" : {}
			})
			hint = result.get("hint", false)
			master_vol = result.get("master_volume", 100)
			victory_vol = result.get("victory_volume", 100)



func _volume_change(vol, db):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(vol), db)
	if vol == "Master":
		master_vol = db
	elif vol == "victory":
		victory_vol = db
	save_game()



func _empty_save():
	best = {
		"none" : {},
		"inverted" : {},
		"anno_un" : {},
		"moving" : {},
		"invisible" : {},
		"ghost" : {},
		"buddy" : {},
		"key" : {},
		"camera" : {}
	}
	hint = false
	master_vol = 100
	victory_vol = 100
	save_game()
