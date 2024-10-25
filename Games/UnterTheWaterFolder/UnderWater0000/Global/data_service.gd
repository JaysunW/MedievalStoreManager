extends Node

var tool_data = {}
var drop_data = {}
var fish_data = {}
var player_data = {}

var tool_data_file_path = "res://JSON/tool_data.json"
var drop_data_file_path = "res://JSON/drop_data.json"
var fish_data_file_path = "res://JSON/fish_data.json"
var player_data_file_path = "res://JSON/player_data.json"

func _ready():
	tool_data = load_json_file(tool_data_file_path)
	drop_data = load_json_file(drop_data_file_path)
	fish_data = load_json_file(fish_data_file_path)
	player_data = load_json_file(player_data_file_path)

func load_json_file(file_path):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file : " + file_path)
	else:
		print("File doesn't exist! : " + file_path)

func set_tool_data(data):
	tool_data = data

func set_player_data(data):
	player_data = data

func get_tool_data():
	return tool_data
	
func get_drop_data():
	return drop_data

func get_fish_data():
	return fish_data

func get_player_data():
	return player_data

func get_complete_dic():
	var dic = {}
	dic["FISH"] = fish_data
	dic["DROP"] = drop_data
	dic["TOOL"] = tool_data
	dic["PLAYER"] = player_data
	return dic

func distribute_dic(dic):
	print(dic)
	if dic:
		fish_data = dic["FISH"]
		drop_data = dic["DROP"]
		tool_data = dic["TOOL"]
		player_data = dic["PLAYER"]

func load_save():
	distribute_dic(SaveService.read_save())
	
func save_data():
	SaveService.write_save(get_complete_dic())
