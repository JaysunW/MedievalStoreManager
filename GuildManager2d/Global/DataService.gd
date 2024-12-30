extends Node

var player_data : Dictionary = {}
var item_data : Dictionary = {}
var shelving_structure_data : Dictionary = {}
var store_structure_data : Dictionary = {}
var decoration_structure_data : Dictionary = {}
var license_data : Dictionary = {}

var player_data_file_path : String = "res://JSON/player_data.json"

func _ready() -> void:
	player_data = load_json_file(player_data_file_path)

func load_json_file(file_path : String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print_debug("Error reading file : " + file_path)
	else:
		print_debug("File doesn't exist! : " + file_path)

func get_data_dictionary():
	var dic = {}
	dic["PLAYER"] = player_data
	dic["ITEM"] = item_data
	return dic

func distribute_dictionary(dic):
	if dic:
		player_data = dic["PLAYER"]
		item_data = dic["ITEM"]
		shelving_structure_data = dic["BUILDING"]
		license_data = dic["LICENSE"]
		
func load_save():
	distribute_dictionary(Save.read_save())
	
func save_data():
	Save.write_save(get_data_dictionary())
