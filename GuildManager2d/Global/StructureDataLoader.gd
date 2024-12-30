extends Control

# Dictionary to hold shop items
var shelving_structure = {}
var store_structure = {}

# Path to your tab-delimited file
var shelving_file_path = "res://CSV/building.txt"
var store_file_path = "res://CSV/structure_store.txt"

func _ready():
	import_shelving_data()
	import_store_data()
	Data.shelving_structure_data = shelving_structure
	Data.store_structure_data = store_structure

func print_every_item(input):
	for id in input:
		var to_print = str(id) + " : {"
		for key in input[id]:
			to_print += key + ": " + str(input[id][key]) + ", "
		to_print += "},"
		print(to_print)
		
# Function to load tab-delimited data from the file
func import_store_data():
	var file_content = load_from_file(store_file_path)
	
	# Skip the first line (header)
	file_content.get_line()

	# Loop through each line
	while not file_content.eof_reached():
		var line = file_content.get_line()
		if line != "":
			var item_data = line.split("\t")
			var id = int(item_data[0])
			var build_name = item_data[1]
			var value = int(item_data[2])
			var sprite_path = item_data[3]
			var unlocked = bool(int(item_data[4]))
			
			# Store the item data in the dictionary
			store_structure[id] = {
				"id": id,
				"name": build_name,
				"value": value,
				"sprite_path": sprite_path,
				"unlocked": unlocked
			}
	file_content.close()	
	
# Function to load tab-delimited data from the file
func import_shelving_data():
	var file_content = load_from_file(shelving_file_path)
	
	# Skip the first line (header)
	file_content.get_line()

	# Loop through each line
	while not file_content.eof_reached():
		var line = file_content.get_line()
		if line != "":
			var item_data = line.split("\t")
			var id = int(item_data[0])
			var build_name = item_data[1]
			var placeable_type = item_data[2]
			var value = int(item_data[3])
			var sprite_path = item_data[4]
			var store_area = item_data[5]
			
			# Store the item data in the dictionary
			shelving_structure[id] = {
				"id": id,
				"name": build_name,
				"placeable_type": placeable_type,
				"value": value,
				"sprite_path": sprite_path,
				"store_area": store_area,
			}
	file_content.close()

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
#	var content = file.get_as_text()
	return file
