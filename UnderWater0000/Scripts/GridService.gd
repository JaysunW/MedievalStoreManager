extends Node

@onready var air_background = $AirBackground
@onready var upper_water_background = $UpperWaterBackground
@onready var water_background = $WaterBackground
@onready var player = $"../Character"
@export var tile : PackedScene
@export var width : int = 100
@export var height : int = 200
@export var chunk_width : int = 20
@export var chunk_height : int = 20
@export var noise_seed : int = 000000

signal drop_at_pos(pos, tile_type)

var counter = 0

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var noise_offset = 10000
var rng = RandomNumberGenerator.new()

var border_amount = 6
var tiles_around_border = 2
var tile_dict = {}
var sprite_name_list = ["1A", "1All","2A", "2All","3A", "3All","4A", "4All","5A", "5All","6A", "6All"]
var water_edge_y = 20 # How many land tiles till water comes

#var saved_chunks = [] # All chunks that have already been loaded
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
	set_sprites_of_tiles()
	transform_backgrounds(width, height)
	player.position = Vector2(float(width * 32)/2.0 -16,-32)

func _process(delta):
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
	if Input.is_action_just_pressed("up"):
		pass

# Spawns tiles depending on x and y input.
func spawn_tiles():
	var jumper = 5
	var ground_jumper = 2
	var ground_start = water_edge_y
	for x in range(width):
		var ground = (noise_one.get_noise_2d(x * ground_jumper, 0) + 1) * 0.5 * ground_start
		for y in range(ground, height):
			var noise_value_1 = (noise_one.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var noise_value_2 = (noise_two.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			#var higherY = float(_y - y) / _y * 0.05
			var y_offset = 5
			var noise_around_zero = noise_value_1 * y_offset - y_offset
			if is_y_around_border(y + noise_around_zero, tiles_around_border) or (noise_value_1 > 0.5 and noise_value_2 > 0.2):
				var newTile = tile.instantiate()
				newTile.position = Vector2(x * 32,y * 32)
				tile_dict[Vector2(x,y)] = newTile
				newTile.set_grid_service($".")
				newTile.call("set_tile_position", Vector2(x,y))
				newTile.call("set_type", get_tile_type_for_area(get_border_area(x,y, true)))
				add_child(newTile)
				newTile.visible = false
				newTile.set_process(false)

func give_chunk_position(pos):
	return Vector2(floor((player.position.x + 16) / (chunk_width * 32)),floor((player.position.y + 16) / (chunk_height * 32)))

func set_chunks_around_loaded_chunk():
	chunks_around_loaded.clear()
	for i in range(-1,2):
		for j in range(-1,2):
			chunks_around_loaded.append(loaded_chunk + Vector2(i,j))

func activate_chunks(pos):
	for y in range(pos.y * chunk_height,(pos.y + 1) * chunk_height):
		for x in range(pos.x * chunk_width,(pos.x + 1) * chunk_width):
			if tile_dict.has(Vector2(x,y)):
				var tile = tile_dict[Vector2(x,y)]
				tile.visible = true
				tile.set_process(true)

func deactivate_chunks(pos):
	for y in range(pos.y * chunk_height,(pos.y + 1) * chunk_height):
		for x in range(pos.x * chunk_width,(pos.x + 1) * chunk_width):
			if tile_dict.has(Vector2(x,y)):
				var tile = tile_dict[Vector2(x,y)]
				tile.visible = false
				tile.set_process(false)

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
			
# Returns the number of Borderarea you are in.
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
	if (tile_dict.has(left)):
		neighbours += "L"
	if (tile_dict.has(right)):
		neighbours += "R"
	if (tile_dict.has(up)):
		neighbours += "U"
	if (tile_dict.has(down)):
		neighbours += "D"
	return neighbours

# Given a certain position update his neighbours sprite.
func update_neighbour_sprite(pos):
	var direction_list = [Vector2(pos.x-1,pos.y), Vector2(pos.x+1,pos.y), Vector2(pos.x,pos.y-1), Vector2(pos.x,pos.y+1)]
	for direction in direction_list:
		if tile_dict.has(direction):
			set_tile_frame(check_where_neighbours(direction), tile_dict[direction].get_node("Sprite"), tile_dict[direction].get_type())

func destroyed_tile(pos, type):
	drop_at_pos.emit(pos, type)
	tile_dict.erase(pos)
	update_neighbour_sprite(pos)

func get_size():
	return Vector2(width, height)
