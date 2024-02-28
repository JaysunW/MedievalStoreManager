extends Node

var tool_data = {}
var drop_data = {}

var tool_data_file_path = "res://JSON/tool_data.json"
var drop_data_file_path = "res://JSON/drop_data.json"

func _ready():
	tool_data = load_json_file(tool_data_file_path)
	drop_data = load_json_file(drop_data_file_path)

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

func get_tool_data():
	return tool_data
	
func get_drop_data():
	return drop_data
