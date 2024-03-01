extends Node2D

var drop_scene : PackedScene

var rng = RandomNumberGenerator.new()

var drop_list = {}
var drop_counter = 0

var gem_drop_chance = 1

func _ready():
	drop_scene = preload("res://Data/Drops/drop.tscn")
	
func set_drop_signal(sig):
	sig.connect(_place_drop_at)

func _place_drop_at( pos, border_idx, drop_type, texture):
	if should_drop_gem(gem_drop_chance * (border_idx + 1)):
		_place_gem_at(pos, border_idx)
	var drop = drop_scene.instantiate()
	add_child(drop)
	drop.position = pos
	drop.set_texture(texture)
	drop.set_border_idx(border_idx)
	drop.set_type(drop_type)
	drop_list[drop_counter] = drop
	if pos.y >= grid_service.water_edge_y:
		drop.gravity_scale = 0.1
	drop.linear_damp = 0.8
	drop.rotation = rng.randi_range(0,360)
	drop.linear_velocity = Vector2(rng.randi_range(-5,6),rng.randi_range(-5,6)) * 8

func should_drop_gem(value):
	return rng.randi_range(0,99) < value
	
func _place_gem_at(pos, border_idx):
	var gem_data_dic = decide_gem(border_idx)
	var drop = drop_scene.instantiate()
	add_child(drop)
	drop.position = pos
	drop.set_texture(load(gem_data_dic["sprite_path"]))
	drop.set_border_idx(border_idx)
	drop.set_type(Enums.DropType.GEM)
	drop_list[drop_counter] = drop
	if pos.y >= grid_service.water_edge_y:
		drop.gravity_scale = 0.1
	drop.linear_damp = 0.8
	drop.rotation = rng.randi_range(0,360)
	drop.linear_velocity = Vector2(rng.randi_range(-5,6),rng.randi_range(-5,6)) * 8
	
func decide_gem(idx):
	var gem_data_list = DataService.get_drop_data()["GEM"]
	var gem_to_look_at = []
	var rarity_max = 10
	var rarity_sum = 0
	var random_int = rng.randi_range(0,99)
	for i in range(gem_data_list.size()):
		var list = gem_data_list[i]["border_idx_list"]
		if list.has(float(idx)):
			gem_to_look_at.append(gem_data_list[i])
			rarity_sum += float(rarity_max - gem_data_list[i]["rarity"])
	var bottom_border_percent = 0
	for gem in gem_to_look_at:
		var area_border_percent = (rarity_max - gem["rarity"])*100/rarity_sum
		var upper_border_percent = bottom_border_percent + area_border_percent
		if bottom_border_percent <= random_int and random_int < upper_border_percent:
			return gem
		bottom_border_percent = upper_border_percent
	print("Something went wrong with the gem decision, maybe faulty rarity of gems : DropService ")
	print("Should be 100: " + str(bottom_border_percent) + " gem_to_look size: " + str(gem_to_look_at.size()) + " randint: "+str(random_int) )
	print("Border_idx :" + str(idx))
	return null

func collect_drop(type, idx):
	var drop_data = DataService.get_drop_data()
	var value = drop_data[Enums.DropType.keys()[type]][idx]["value"]
#	print("Added: " + str(value) + " Gold : drop_service")
	GoldService.add_gold(value)

func erase_drop(drop):
	drop_list.erase(drop)
