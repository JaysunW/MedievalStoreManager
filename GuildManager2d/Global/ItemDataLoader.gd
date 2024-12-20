extends Control

# Dictionary to hold shop items
var shop_items = {}

# Path to your tab-delimited file
var txt_file_path = "res://CSV/shop_item.txt"

func _ready():
	import_shop_item_data()
	Data.item_data = shop_items
	#print_every_item()

func print_every_item():
	for id in shop_items:
		var to_print = str(id) + " : {"
		for key in shop_items[id]:
			to_print += key + ": " + str(shop_items[id][key]) + ", "
		to_print += "},"
		print(to_print)

func import_shop_item_data():
	var file_content = load_from_file(txt_file_path)
	
	file_content.get_line()

	while not file_content.eof_reached():
		var line = file_content.get_line()
		if line != "":
			var item_data = line.split("\t")
			
			var id = int(item_data[0])
			var item_name = item_data[1]
			var type = item_data[2]
			var store_area = item_data[3]
			var value = int(item_data[4])
			var market_value = int(item_data[5])
			var sprite_path = item_data[6]
			var amount = int(item_data[7])
			var carry_max = int(item_data[8])
			var max_amount = int(item_data[9])
			
			shop_items[id] = {
				"id": id,
				"name": item_name,
				"type": type,
				"store_area": store_area,
				"value": value,
				"market_value": market_value,
				"sprite_path": sprite_path,
				"amount": amount,
				"carry_max": carry_max,
				"max_amount":max_amount,
			}
	file_content.close()


func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	return file
