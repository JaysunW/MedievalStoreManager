extends Node

var tool_data = {}

var tool_data_file_path = "res://JSON/ToolStats.json"

func _ready():
	tool_data = load_json_file(tool_data_file_path)

func load_json_file(file_path):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
	else:
		print("File doesn't exist!")

func get_tool_stats():
	return tool_data

func set_tool_stats(data):
	tool_data = data
