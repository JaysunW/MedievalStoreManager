extends RigidBody2D

@export var max_health = 100
var grid_service = null
var tile_position = Vector2(0,0)
var tile_type = Enums.TileType.UNKNOWN

var health = 0
var hardness = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# Mine tile by a certain amount of damage
func mine(damage):
	health -= damage
	if health <= 0:
		destroy_tile()
		
	# Sets destruction texture of the tile
	var destruction_sprite = $Destruction
	var frame_count = destruction_sprite.sprite_frames.get_frame_count("default")
	destruction_sprite.frame = frame_count - int (float(health)/float(max_health) * frame_count)
	

func set_hardness(input):
	hardness = input
func set_grid_service(input):
	grid_service = input
func set_tile_position(input):
	tile_position = input
func set_type(input):
	tile_type = input
	
func get_hardness():
	return hardness
func get_type():
	return tile_type
func get_tile_position():
	return tile_position
	
func get_spawn_from_dir(dir):
	match dir:
		Enums.Dir.North:
			return $NorthSpawn
		Enums.Dir.East:
			return $EastSpawn
		Enums.Dir.South:
			return $SouthSpawn
		Enums.Dir.West:
			return $WestSpawn
			
# Destroy tile and remove it from the main tile dictionary
func destroy_tile():
	grid_service.call("destroyed_tile",tile_position, tile_type)
	queue_free()
