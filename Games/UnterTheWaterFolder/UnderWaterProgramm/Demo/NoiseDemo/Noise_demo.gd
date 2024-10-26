extends Node2D

@export var tile:PackedScene
var noise = FastNoiseLite.new()
var flowness = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var density = FastNoiseLite.new()
@export var width = 200.0
@export var height = 200.0
var tile_list = []
 
# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	flowness.seed = randi()
	temperature.seed = randi()
	density.seed = randi()
	$FreeCam.position = world_to_tile_position(Vector2(width/2,height/2))
	generate_chunk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): 
	if Input.is_action_just_pressed("r"):
		for _tile in tile_list:
			_tile.queue_free()
		tile_list.clear()
		noise.seed = randi()
		flowness.seed = randi()
		temperature.seed = randi()
		density.seed = randi()
		generate_chunk()
	
func world_to_tile_position(pos):
	return Vector2(pos.x * 32, pos.y * 32)

func generate_chunk():
	var jumper = 3
	var ground_jumper = 2
	var ground_start = 20
	for x in range(width):
		var ground = (noise.get_noise_2d(x * ground_jumper, 0) + 1) * 0.5 * ground_start
		for y in range(ground, height):
			var noise_val = (noise.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var flow = (flowness.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var dense = (density.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5 
			var temp = (temperature.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5 
			var newTile = tile.instantiate()
			newTile.position = world_to_tile_position(Vector2(x,y))
			var higherY = (height - y) / height
			var lowerY = y / height
			#print("Dens: " + str(dense) + " temp: " + str(temp) + " flow: " + str(flow))
			if flow < 0.5:
				newTile.get_node("Sprite").self_modulate = Color(1,1,1)
			else:
				newTile.get_node("Sprite").self_modulate = Color(0,0,0)
			noise_val = flow
			#newTile.get_node("Sprite").self_modulate = Color(noise_val,noise_val,noise_val)
			add_child(newTile)
			tile_list.append(newTile)
