extends Node

var json = JSON.new()
var path = "user://data.json"

var data = {}

func write_save(content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	file = null
	
func read_save():
	var file = FileAccess.open(path, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	print_debug(Data.player_data)
	return content
	
func create_new_save_file():
	var file = FileAccess.open("res://Resource/default_save.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	data = content
	write_save(content)
	
func _ready():
#	print_debug(read_save()["PLAYER"])
#	if read_save():
#		print_debug("Theres something")
#	else:
#		print_debug("Theres nothing")
	pass

func _process(_delta):
#	if Input.is_action_just_pressed("z"):
#		create_new_save_file()
	pass
	
