extends Node

@export var tile : PackedScene
@export var width : int = 16
@export var height : int = 16
@export var noise_seed : int = 000000

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var noise_offset = 10000
var rng = RandomNumberGenerator.new()

var counter = 0

var border_amount = 6
var tile_dict = {}
var tile_type_dict = {}
var sprite_name_list = ["1A", "1All","2A", "2All","3A", "3All","4A", "4All","5A", "5All","6A", "6All"]

var water_edge_y = 20 # How many land tiles till water comes

@onready var upper_water_background = $UpperWaterBackground
@onready var water_background = $WaterBackground
@onready var air_background = $AirBackground

# Called when the node enters the scene tree for the first time.
func _ready():
	noise_one.seed = noise_seed
	noise_two.seed = noise_seed + noise_offset
	temperature.seed = noise_seed + noise_offset * 2
	moisture.seed = noise_seed + noise_offset * 3
	spawn_tiles(width, height)
	transform_backgrounds(width, height)
	$"../Character".position = Vector2(float(width * 32)/2.0 -16,-32)
	$"../FreeCam".position = Vector2(float(width * 32)/2 -16,-32)
	set_sprites_of_tiles()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# Spawns tiles depending on x and y input
func spawn_tiles(_x, _y):
	var jumper = 6
	var ground_jumper = 2
	var ground_start = water_edge_y
	for x in range(_x):
		var ground = (noise_one.get_noise_2d(x * ground_jumper, 0) + 1) * 0.5 * ground_start
		for y in range(ground, _y):
			var noise_value_1 = (noise_one.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var noise_value_2 = (noise_two.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var temp = (temperature.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var moist = (moisture.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var higherY = (_y - y) / _y
			if is_y_around_border(y + round(noise_value_1 * 6 - 6), 3) or (noise_value_1 + higherY * 0.2 > 0.5 and noise_value_2 + higherY * 0.2 > 0.2):
				var newTile = tile.instantiate()
				newTile.position = Vector2(x * 32,y * 32)
				newTile.call("set_tile_position", Vector2(x,y))
				tile_dict[Vector2(x,y)] = newTile
				tile_type_dict[Vector2(x,y)] = get_border_area(x,y) * 2
				add_child(newTile)
	
func get_border_area(x, y):
	var border_height = float(height) / border_amount
	var noise_offset = noise_one.get_noise_2d(x * 4, y * 4) * 5
	var new_y = y + noise_offset
	for i in range(border_amount):
		if (border_height * (i + 1) > new_y and new_y >= border_height * i) or i == border_amount-1:
			return i

func is_y_at_border(y):
	var border_height = round(height / border_amount)
	for i in range(border_amount):
		if y == border_height * i:
			return true
	return false

func is_y_around_border(y, offset):
	var border_height = round(height / border_amount)
	for i in range(border_amount):
		if (border_height * i + offset > y and y >= border_height * i - offset) or y > height - offset * 2:
			return true
	return false
				
# Sets the backgrounds for for air and water area 
func transform_backgrounds(_x, _y):
	upper_water_background.position = Vector2((_x - 1) * 32 / 2, 32 * 0.05 + water_edge_y * 32)
	upper_water_background.scale = Vector2(_x * 2, 1-0.1)
	
	water_background.position = Vector2((_x - 1) * 32 / 2, (_y) * 32 / 2 + water_edge_y * 32)
	water_background.scale = Vector2(_x * 2, _y - 1)
	
	air_background.position = Vector2((_x - 1) * 32 / 2, -26.2 * 32 + water_edge_y * 32)
	air_background.scale = Vector2(_x * 2, 50)

# Sets the sprite of every tile
func set_sprites_of_tiles():
	for y in range(height):
		for x in range(width):
			if tile_dict.has(Vector2(x,y)):
				set_frame(check_where_neighbours(Vector2(x,y)), tile_dict[Vector2(x,y)].get_node("Sprite"), tile_type_dict[Vector2(x,y)])

# Given a string of neighbours and a sprite, change the sprite accordingly
func set_frame(neighbours, sprite, type_val):
	sprite.animation = sprite_name_list[type_val]
	match neighbours:
		"LRUD":
			sprite.animation = sprite_name_list[type_val + 1]
			sprite.frame = rng.randi_range(0,sprite.sprite_frames.get_frame_count(sprite_name_list[type_val + 1]))
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

# Given a certain position check where the neighbours are and give back their positions in string
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

# Given a certain position update his neighbours sprite
func update_neighbour_sprite(pos):
	var direction_list = [Vector2(pos.x-1,pos.y), Vector2(pos.x+1,pos.y), Vector2(pos.x,pos.y-1), Vector2(pos.x-1,pos.y+1)]
	for direction in direction_list:
		if tile_dict.has(direction):
			set_frame(check_where_neighbours(direction), tile_dict[direction].get_node("Sprite"), tile_type_dict[direction])

# Does something when a Tile gets deleted
func _on_child_exiting_tree(node):
	if node.get_groups().has("Tiles"):
		var destroyed_tile_position = node.get_tile_position()
		tile_dict.erase(destroyed_tile_position)
		tile_type_dict.erase(destroyed_tile_position)
		update_neighbour_sprite(destroyed_tile_position)
