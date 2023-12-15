extends Node2D

@export var tile:PackedScene
var noise = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 256
var height = 64
var tile_list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	$FreeCam.position = world_to_tile_position(Vector2(width/2,height/2))
	generate_chunk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("r"):
		for tile in tile_list:
			tile.queue_free()
		tile_list.clear()
		moisture.seed = randi()
		temperature.seed = randi()
		altitude.seed = randi()
		generate_chunk()
	
func world_to_tile_position(pos):
	return Vector2(pos.x * 32, pos.y * 32)

func generate_chunk():
	var jumper = 3
	var ground_jumper = 1
	for x in range(width):
		var ground = abs(noise.get_noise_2d(x * ground_jumper, 0) * 8)
		for y in range(ground, height):
			var moist = (moisture.get_noise_2d(x * jumper, y * jumper) + 1) * 5
			var temp = (temperature.get_noise_2d(x * jumper, y * jumper) + 1) * 5
			var alt = (altitude.get_noise_2d(x * jumper, y * jumper) + 1) * 5
			if moist > 2 and temp > 5:
				var newTile = tile.instantiate()
				newTile.position = world_to_tile_position(Vector2(x,y))
				add_child(newTile)
				tile_list.append(newTile)
