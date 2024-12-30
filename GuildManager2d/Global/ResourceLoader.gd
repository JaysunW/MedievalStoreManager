extends Node

func texture(path):
	if FileAccess.file_exists(path):
		return load(path)
	else:
		return load("res://Asset/32x32white.png")

func shop_item_texture(string : String, small_version = false):
	string = string + ".png"
	var path = "res://Asset/ShopItem/"
	if small_version:
		path = path + "SmallVersion/"
	path = path + string

	if FileAccess.file_exists(path):
		return load(path)
	else:
		return load("res://Asset/32x32white.png")

func load_structure_resource(string : String):
	string = string.to_lower() + ".tscn"
	var path = "res://Main/Data/Structure/Scene/"
	path = path + string

	if FileAccess.file_exists(path):
		return load(path)
	else:
		return null
