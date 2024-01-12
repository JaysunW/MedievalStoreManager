extends Node2D

var all_counter = 0

@onready var air_background = $AirBackground
@onready var upper_water_background = $UpperWaterBackground
@onready var water_background = $WaterBackground
@onready var player = $"../Character"
@onready var chunk_border_show = $ChunkPerimeter
@export var tile_scene : PackedScene
@export var coral_scene : PackedScene
@export var shell_scene : PackedScene
@export var test_scene : PackedScene
@export var width : int = 100
@export var height : int = 200
@export var chunk_width : int = 20
@export var chunk_height : int = 20

var show_chunks = true
var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var noise_seed : int = 0
var noise_offset = 100000
var noise_jump = 6
var noise_ground_jump = 2
var rng = RandomNumberGenerator.new()

var border_amount = 6
var tiles_around_border = 2
var tile_dict = {}
var sprite_name_list = ["1A", "1All","2A", "2All","3A", "3All","4A", "4All","5A", "5All","6A", "6All"]
var water_edge_y = 5 # How many land tiles till water comes

#var saved_chunks = [] # All chunks that have already been loaded
@export var fill_every_tile = false
@export var show_every_tile = false
var loaded_chunk = Vector2.ZERO
var chunks_around_loaded = []

# Called when the node enters the scene tree for the first time.
func _ready():
	water_edge_y = min(float(height)/10,15)
	noise_one.seed = noise_seed
	noise_two.seed = noise_seed + noise_offset
	temperature.seed = noise_seed + noise_offset * 2
	moisture.seed = noise_seed + noise_offset * 3
	spawn_tiles()
	spawn_foliage()
	set_sprites_of_tiles()
	transform_backgrounds(width, height)
	player.position = Vector2(float(width * 32)/2.0,-32)

func _process(_delta):
	if not show_every_tile:
		var player_chunk = give_chunk_position(player.position)
		if loaded_chunk != player_chunk:
			loaded_chunk = player_chunk
			var old_loaded_chunk = chunks_around_loaded + []
			set_chunks_around_loaded_chunk()
			for chunk in chunks_around_loaded:
				if chunk not in old_loaded_chunk:
					activate_chunks(chunk)
			for chunk in old_loaded_chunk:
				if chunk not in chunks_around_loaded:
					deactivate_chunks(chunk)
#	if Input.is_action_just_pressed("o"):
#		GoldService.add_gold(1)
#		print(GoldService.get_gold())
#	if Input.is_action_just_pressed("p"):
#		GoldService.set_gold(100)
#		print(GoldService.get_gold())
#	if Input.is_action_just_pressed("i"):
#		print(GoldService.get_gold())
#		SceneSwitcherService.switch_scene("res://Data/MainScenes/shop.tscn")
#		print("Gold: ")
#		print(GoldService.get_gold())
		
# Spawns tiles depending on x and y input.
func spawn_tiles():
	var ground_start = water_edge_y + 10
	for x in range(width):
		var ground = (noise_one.get_noise_2d(x * noise_ground_jump, 0) + 1) * 0.5 * ground_start
		for y in range(ground, height):
			var noise_value_1 = (noise_one.get_noise_2d(x * noise_jump, y * noise_jump) + 1) * 0.5
			var noise_value_2 = (noise_two.get_noise_2d(x * noise_jump, y * noise_jump) + 1) * 0.5
			#var higherY = float(_y - y) / _y * 0.05
			var y_offset = 5
			var noise_around_zero = noise_value_1 * y_offset - y_offset
			if fill_every_tile or y == height - 1 or is_y_around_border(y + noise_around_zero, tiles_around_border) or (noise_value_1 > 0.5 and noise_value_2 > 0.2):
				var newTile = tile_scene.instantiate()
				add_child(newTile)
				var border_idx = get_border_area(x,y, true)
				newTile.position = Vector2(x * 32,y * 32)
				# Puts harder tiles in the middle of a chunk
				if (noise_value_1 > 0.8 and noise_value_2 > 0.6): border_idx += 2
				elif (noise_value_1 > 0.7 and noise_value_2 > 0.4): border_idx += 1
				if border_idx >= border_amount: border_idx = 0
				# Sets stats of the tile
				newTile.call("set_grid_service", $".")
				newTile.call("set_tile_position", Vector2(x,y))
				newTile.call("set_type", get_tile_type_for_area(border_idx))
				newTile.call("set_hardness", border_idx)
				tile_dict[Vector2(x,y)] = newTile
				if not show_every_tile:
					newTile.visible = false
					newTile.set_process(false)

func rand_chance(chance):
	return rng.randf_range(0,100) < chance

func spawn_foliage():
	var foliage_noise_jump = 10
	var ground_start = water_edge_y + 10
	var shell_noise_offset = 1000
	for x in range(width):
		var ground = (noise_one.get_noise_2d(x * noise_ground_jump, 0) + 1) * 0.5 * ground_start
		for y in range(ground, height):
			var noise_value_1 = (noise_one.get_noise_2d(x * foliage_noise_jump, y * foliage_noise_jump) + 1) * 0.5
			var noise_value_2 = (noise_two.get_noise_2d(x * foliage_noise_jump , y * foliage_noise_jump) + 1) * 0.5
			var pos = Vector2(x,y)
			if tile_dict.has(pos) and y > water_edge_y:
				var current_tile = tile_dict[pos]
				var neighbours = check_where_neighbours(pos)
				if neighbours != "LRUD" and noise_value_1 > 0.4 and noise_value_2 > 0.6:
					var dir_list = []
					if not neighbours.contains("L") and rand_chance(80):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.West))
					if not neighbours.contains("R") and rand_chance(80):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.East))
					if not neighbours.contains("U") and rand_chance(60):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.North))
					if not neighbours.contains("D") and rand_chance(60):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.South))
					for dir in dir_list:
						var coral = coral_scene.instantiate()
						dir.add_child(coral)
						coral.call("set_type", current_tile.get_type())
						coral.call("update_sprite")
			noise_value_1 = (noise_one.get_noise_2d((x + shell_noise_offset) * foliage_noise_jump, (y + shell_noise_offset) * foliage_noise_jump) + 1) * 0.5
			noise_value_2 = (noise_two.get_noise_2d((x + shell_noise_offset) * foliage_noise_jump , (y + shell_noise_offset) * foliage_noise_jump) + 1) * 0.5
			pos = Vector2(x,y)
			if tile_dict.has(pos) and y > water_edge_y:
				var current_tile = tile_dict[pos]
				var neighbours = check_where_neighbours(pos)
				if neighbours != "LRUD" and noise_value_1 > 0.4 and noise_value_2 > 0.6:
					var dir_list = []
					if not neighbours.contains("L") and rand_chance(30):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.West))
					if not neighbours.contains("R") and rand_chance(30):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.East))
					if not neighbours.contains("U") and rand_chance(50):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.North))
					if not neighbours.contains("D") and rand_chance(50):
						dir_list.append(current_tile.get_spawn_from_dir(Enums.Dir.South))
#					if not neighbours.contains("L") and rand_chance(30):
#						dir_list.append(Enums.Dir.West)
#					if not neighbours.contains("R") and rand_chance(30):
#						dir_list.append(Enums.Dir.East)
#					if not neighbours.contains("U") and rand_chance(50):
#						dir_list.append(Enums.Dir.North)
#					if not neighbours.contains("D") and rand_chance(50):
#						dir_list.append(Enums.Dir.South)
					for dir in dir_list:
						var shell = shell_scene.instantiate()
						dir.add_child(shell)
						shell.call("set_type", current_tile.get_type())
						shell.call("update_sprite")
						
			
	
func give_chunk_position(pos):
	return Vector2(floor((pos.x + 16) / (chunk_width * 32)),floor((pos.y + 16) / (chunk_height * 32)))

func set_chunks_around_loaded_chunk():
	chunk_border_show.clear_points()
	chunks_around_loaded.clear()
	var loaded_chunk_pos = Vector2((loaded_chunk.x) * chunk_width,(loaded_chunk.y) * chunk_height)
	for i in range(-1,2):
		for j in range(-1,2):
			chunks_around_loaded.append(loaded_chunk + Vector2(i,j))
			if show_chunks:
				chunk_border_show.add_point((loaded_chunk_pos + Vector2((i) * chunk_width,(j) * chunk_height)) * 32)
				chunk_border_show.add_point((loaded_chunk_pos + Vector2((i + 1) * chunk_width,(j) * chunk_height)) * 32)
				chunk_border_show.add_point((loaded_chunk_pos + Vector2((i + 1) * chunk_width,(j + 1) * chunk_height)) * 32)
				chunk_border_show.add_point((loaded_chunk_pos + Vector2((i) * chunk_width,(j + 1) * chunk_height)) * 32)
				chunk_border_show.add_point((loaded_chunk_pos + Vector2((i) * chunk_width,(j) * chunk_height)) * 32)
		if show_chunks:
			chunk_border_show.add_point((loaded_chunk_pos + Vector2((i) * chunk_width,(-1) * chunk_height)) * 32)

# Activates the chunk at pos
func activate_chunks(pos):
	for y in range(pos.y * chunk_height,(pos.y + 1) * chunk_height):
		for x in range(pos.x * chunk_width,(pos.x + 1) * chunk_width):
			if tile_dict.has(Vector2(x,y)):
				var tile_to_activate = tile_dict[Vector2(x,y)]
				tile_to_activate.visible = true
				tile_to_activate.set_process(true)

# Deactivates the chunk at pos
func deactivate_chunks(pos):
	for y in range(pos.y * chunk_height,(pos.y + 1) * chunk_height):
		for x in range(pos.x * chunk_width,(pos.x + 1) * chunk_width):
			if tile_dict.has(Vector2(x,y)):
				var tile_to_deactivate = tile_dict[Vector2(x,y)]
				tile_to_deactivate.visible = false
				tile_to_deactivate.set_process(false)

# For input of border area gives corresponding tile type
func get_tile_type_for_area(input):
	match input:
		0:
			return Enums.TileType.A0
		1:
			return Enums.TileType.A1
		2:
			return Enums.TileType.A2
		3:
			return Enums.TileType.A3
		4:
			return Enums.TileType.A4
		5:
			return Enums.TileType.A5
		_:
			return Enums.TileType.UNKNOWN
			
# Returns the number of borderarea you are in.
func get_border_area(x, y, is_with_noise = false):
	var border_height = float(height) / border_amount
	var y_offset = noise_one.get_noise_2d(x * 4, y * 4) * 5
	var new_y = max(y + y_offset, 0)
	for i in range(border_amount):
		if is_with_noise:
			if (border_height * (i + 1) > new_y and new_y >= border_height * i) or i == border_amount-1:
				return i
		else:
			if (border_height * (i + 1) > y and y >= border_height * i) or i == border_amount-1:
				return i

# Returns true, if the given y is on the border of the areas.
func is_y_at_border(y):
	var border_height = round(float(height) / border_amount)
	for i in range(border_amount):
		if y == border_height * i:
			return true
	return false

# Returns true, if the given y is around an offset of one of the border areas.
func is_y_around_border(y, offset):
	var border_height = round(float(height) / border_amount)
	for i in range(border_amount):
		if (border_height * i + offset > y and y >= border_height * i - offset) or y > height - offset * 2:
			return true
	return false
				
# Sets the backgrounds for air and water area.
func transform_backgrounds(_x, _y):
	upper_water_background.position = Vector2((_x - 1) * 32 / 2, 32 * 0.05 + water_edge_y * 32)
	upper_water_background.scale = Vector2(_x * 2, 1-0.1)
	
	water_background.position = Vector2((_x - 1) * 32 / 2, (_y) * 32 / 2 + water_edge_y * 32)
	water_background.scale = Vector2(_x * 2, _y - 1)
	
	air_background.position = Vector2((_x - 1) * 32 / 2, -26.2 * 32 + water_edge_y * 32)
	air_background.scale = Vector2(_x * 2, 50)

# Sets the sprite of every tile.
func set_sprites_of_tiles():
	for y in range(height):
		for x in range(width):
			if tile_dict.has(Vector2(x,y)):
				var neighbours = check_where_neighbours(Vector2(x,y))
				set_tile_frame(neighbours, tile_dict[Vector2(x,y)].get_node("Sprite"), tile_dict[Vector2(x,y)].get_type())
				if y < water_edge_y + 1:
					set_tile_greenery(neighbours, tile_dict[Vector2(x,y)].get_node("Greenery"))
					
# Given a string of neighbours and the sprite of a tile set its greenery.
func set_tile_greenery(neighbours, sprite):
	sprite.visible = true
	match neighbours:
		"L":
			sprite.frame = 1
		"R":
			sprite.frame = 3
		"D":
			sprite.frame = 0
		"U":
			sprite.frame = 6
		"LD":
			sprite.frame = 1
		"RD":
			sprite.frame = 3
		"LR":
			sprite.frame = 4
		"LU":
			sprite.frame = 2
		"RU":
			sprite.frame = 5
		"UD":
			sprite.frame = 6
		"LRD":
			sprite.frame = 4
		"LUD":
			sprite.frame = 2
		"RUD":
			sprite.frame = 5
		"":
			sprite.frame = 0
		_:
			sprite.visible = false

# Given a string of neighbours, the sprite of a tile and a type, change the sprite accordingly.
func set_tile_frame(neighbours, sprite, type_val):
	sprite.animation = sprite_name_list[type_val * 2]
	match neighbours:
		"LRUD":
			sprite.animation = sprite_name_list[type_val * 2 + 1]
			sprite.frame = rng.randi_range(0,sprite.sprite_frames.get_frame_count(sprite_name_list[type_val * 2 + 1]))
		"D":
			sprite.frame = 1
		"LD":
			sprite.frame = 2
		"L":
			sprite.frame = 3
		"R":
			sprite.frame = 4
		"RD":
			sprite.frame = 5
		"LRD":
			sprite.frame = 6
		"LR":
			sprite.frame = 7
		"U":
			sprite.frame = 8
		"UD":
			sprite.frame = 9
		"LUD":
			sprite.frame = 10
		"LU":
			sprite.frame = 11
		"RU":
			sprite.frame = 12
		"RUD":
			sprite.frame = 13
		"LRU":
			sprite.frame = 14
		"":
			sprite.frame = 0

# Given a certain position check where the neighbours are and give back their positions in string.
func check_where_neighbours(pos):
	var neighbours = ""
	var left = Vector2(pos.x-1,pos.y)
	var right = Vector2(pos.x+1,pos.y)
	var up = Vector2(pos.x,pos.y-1)
	var down = Vector2(pos.x,pos.y+1)
	if (tile_dict.has(left) or left.x < 0):
		neighbours += "L"
	if (tile_dict.has(right) or right.x >= width):
		neighbours += "R"
	if (tile_dict.has(up) or up.y < 0):
		neighbours += "U"
	if (tile_dict.has(down) or down.y >= height):
		neighbours += "D"
	return neighbours

# Given a certain position update his neighbours sprite.
func update_neighbour_sprite(pos):
	var direction_list = [Vector2(pos.x-1,pos.y), Vector2(pos.x+1,pos.y), Vector2(pos.x,pos.y-1), Vector2(pos.x,pos.y+1)]
	for direction in direction_list:
		if tile_dict.has(direction):
			set_tile_frame(check_where_neighbours(direction), tile_dict[direction].get_node("Sprite"), tile_dict[direction].get_type())

func destroyed_tile(pos, type):
	DropService.call("place_tile_drop_at", pos, type, pos.y >= water_edge_y)
	tile_dict.erase(pos)
	update_neighbour_sprite(pos)

func get_size():
	return Vector2(width, height)
