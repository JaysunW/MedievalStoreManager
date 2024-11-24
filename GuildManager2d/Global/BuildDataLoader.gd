extends Control

# Dictionary to hold shop items
var buildings = {}

# Path to your tab-delimited file
var txt_file_path = "res://CSV/building.txt"

func _ready():
	import_shop_item_data()
	Data.building_data = buildings
#	print_every_item()

func print_every_item():
	# Test by printing the items
	for id in buildings:
		print_debug("Item: ", buildings[id]["name"], ", type: ", buildings[id]["type"], ", value: ", buildings[id]["value"],", sprite_path: ", buildings[id]["sprite_path"], ", unlocked: ", buildings[id]["unlocked"])

# Function to load tab-delimited data from the file
func import_shop_item_data():
	var file_content = load_from_file(txt_file_path)
	
	# Skip the first line (header)
	file_content.get_line()

	# Loop through each line
	while not file_content.eof_reached():
		var line = file_content.get_line()
		if line != "":
			var item_data = line.split("\t")
			
			var id = int(item_data[0])
			var build_name = item_data[1]
			var type = item_data[2]
			var value = int(item_data[3])
			var sprite_path = item_data[4]
			var unlocked = bool(int(item_data[5]))
			
			# Store the item data in the dictionary
			buildings[id] = {
				"id": id,
				"name": build_name,
				"type": type,
				"value": value,
				"sprite_path": sprite_path,
				"unlocked": unlocked,
			}
	file_content.close()

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
#	var content = file.get_as_text()
	return file
