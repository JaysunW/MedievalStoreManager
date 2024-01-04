extends Node2D

var grid_service = null
var tile_position = Vector2(0,0)
var type = Enums.TileType.UNKNOWN

var max_health = 100
var health = max_health
var hardness = 1

func _ready():
	pass

func _process(_delta):
	pass
	
# Mine tile by a certain amount of damage
func mine(damage):
	health -= damage
	if health <= 0:
		destroy_tile()
		return
		
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
	type = input
	
func get_hardness():
	return hardness
func get_type():
	return type
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
			
func add_object_to_dir(object, dir):
	match dir:
		Enums.Dir.North:
			$NorthSpawn.add_child(object)
		Enums.Dir.East:
			$EastSpawn.add_child(object)
		Enums.Dir.South:
			$SouthSpawn.add_child(object)
		Enums.Dir.West:
			$WestSpawn.add_child(object)
			
# Destroy tile and remove it from the main tile dictionary
func destroy_tile():
	grid_service.call("destroyed_tile",tile_position, type)
	queue_free()
