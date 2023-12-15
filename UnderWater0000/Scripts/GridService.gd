extends Node

@export var tile : PackedScene
@export var width : int = 16
@export var height : int = 16

var rng = RandomNumberGenerator.new()
var tile_dict = {}

# How many land tiles till water comes
var water_edge_y = 5
@onready var upper_water_background = $UpperWaterBackground
@onready var water_background = $WaterBackground
@onready var air_background = $AirBackground

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_tiles(width, height)
	$"../Character".position = Vector2(width * 32/2 -16,-32)
	$"../FreeCam".position = Vector2(width * 32/2 -16,-32)
	transform_backgrounds(width, height)
	set_sprites()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Spawns tiles depending on x and y input
func spawn_tiles(_x, _y):
	for y in range(_y):
		for x in range(_x):
			var newTile = tile.instantiate()
			newTile.position = Vector2(x * 32,y * 32)
			newTile.call("set_tile_position", Vector2(x,y))
			tile_dict[Vector2(x,y)] = newTile
			add_child(newTile)

func transform_backgrounds(_x, _y):
	upper_water_background.position = Vector2((_x - 1) * 32 / 2, 32 * 0.05 + water_edge_y * 32)
	upper_water_background.scale = Vector2(_x * 2, 1-0.1)
	
	water_background.position = Vector2((_x - 1) * 32 / 2, (_y) * 32 / 2 + water_edge_y * 32)
	water_background.scale = Vector2(_x * 2, _y - 1)
	
	air_background.position = Vector2((_x - 1) * 32 / 2, -9.2 * 32 + water_edge_y * 32)
	air_background.scale = Vector2(_x * 2, 16)

# Sets the sprite of every tile
func set_sprites():
	for y in range(height):
		for x in range(width):
			set_frame(check_where_neighbours(Vector2(x,y)), tile_dict[Vector2(x,y)].get_node("Sprite"))

# Given a string of neighbours and a sprite, change the sprite accordingly
func set_frame(neighbours, sprite):
	sprite.animation = "Side"
	match neighbours:
		"LRUD":
			sprite.animation = "AllSide"
			sprite.frame = rng.randi_range(0,sprite.sprite_frames.get_frame_count("AllSide"))
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
	var left = Vector2(pos.x-1,pos.y)
	var right = Vector2(pos.x+1,pos.y)
	var up = Vector2(pos.x,pos.y-1)
	var down = Vector2(pos.x,pos.y+1)
	if tile_dict.has(left):
		set_frame(check_where_neighbours(left), tile_dict[left].get_node("Sprite"))
	if tile_dict.has(right):
		set_frame(check_where_neighbours(right), tile_dict[right].get_node("Sprite"))
	if tile_dict.has(up):
		set_frame(check_where_neighbours(up), tile_dict[up].get_node("Sprite"))
	if tile_dict.has(down):
		set_frame(check_where_neighbours(down), tile_dict[down].get_node("Sprite"))

func _on_child_exiting_tree(node):
	if node.get_groups().has("Tiles"):
		var destroyed_tile_position = node.get_tile_position()
		tile_dict.erase(destroyed_tile_position)
		update_neighbour_sprite(destroyed_tile_position)
