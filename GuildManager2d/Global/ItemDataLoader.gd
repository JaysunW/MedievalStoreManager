extends Control

# Dictionary to hold shop items
var shop_items = {}

# Path to your tab-delimited file
var txt_file_path = "res://CSV/shop_item.txt"

func _ready():
	import_shop_item_data()
	Data.item_data = shop_items
#	print_every_item()

func print_every_item():
	for id in shop_items:
		print_debug("Item: ", shop_items[id]["name"], ", type: ", shop_items[id]["type"], ", store_area: ", shop_items[id]["store_area"],", value: ", shop_items[id]["value"],
		 ", Average Value: ", shop_items[id]["market_value"], ", unlocked: ", shop_items[id]["unlocked"], ", sprite_path: ", shop_items[id]["sprite_path"],
		 ", amount: ", shop_items[id]["amount"], ", carry_max: ", shop_items[id]["carry_max"], ", max_amount: ", shop_items[id]["max_amount"], ", average_color: ", shop_items[id]["average_color"] )

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
			var average_value = int(item_data[5])
			var unlocked = bool(int(item_data[6]))
			var sprite_path = item_data[7]
			var amount = int(item_data[8])
			var carry_max = int(item_data[9])
			var max_amount = int(item_data[10])
			var color_value_list = parse_average_color(item_data[11])
			
			shop_items[id] = {
				"id": id,
				"name": item_name,
				"type": type,
				"store_area": store_area,
				"value": value,
				"market_value": average_value,
				"unlocked": unlocked,
				"sprite_path": sprite_path,
				"amount": amount,
				"carry_max": carry_max,
				"max_amount":max_amount,
				"average_color": color_value_list
			}
	file_content.close()

func parse_average_color(input):
	var string_list = input.split(",")
	print("string_list: ", string_list)
	var color_value_list = []
	for string in string_list:
		color_value_list.append(float(string)/255)
	print("color_list: ", color_value_list)
	return color_value_list

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	return file
