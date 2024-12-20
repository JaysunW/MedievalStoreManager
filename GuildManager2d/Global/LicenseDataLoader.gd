extends Control

# Dictionary to hold shop items
var licenses = {}

# Path to your tab-delimited file
var txt_file_path = "res://CSV/item_license.txt"

func _ready():
	import_shop_item_data()
	Data.license_data = licenses
	#print_every_item()

func print_every_item():
	for id in licenses:
		var to_print = str(id) + " : {"
		for key in licenses[id]:
			to_print += key + ": " + str(licenses[id][key]) + ", "
		to_print += "},"
		print(to_print)
		
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
			var license_name = item_data[1]
			var unlocked_by = parse_license_unlocked_by(item_data[2])
			var value = int(item_data[3])
			var description = item_data[4]
			var sprite_path = item_data[5]

			# Store the item data in the dictionary
			licenses[id] = {
				"id": id,
				"name": license_name,
				"unlocked_by": unlocked_by,
				"value": value,
				"description": description,
				"sprite_path": sprite_path
			}
	file_content.close()

func parse_license_unlocked_by(input):
	var output = input.split(",")
	if output[0] == "":
		return []
	return output

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
#	var content = file.get_as_text()
	return file
