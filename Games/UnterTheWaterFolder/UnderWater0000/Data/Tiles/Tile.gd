extends Node2D

var tile_position = Vector2(0,0)

var max_health = 100
var health = max_health
var hardness = 1
var drop_type = Enums.DropType.TILE
var destroyable = true

signal destroyed(type_position)
signal dropped(pos, hardness, drop_type, sprite)

func _ready():
	pass

func _process(_delta):
	pass

#  Mine tile by a certain amount of damage
func mine(damage):
	if destroyable:
		health -= damage
		if health <= 0:
			destroy_tile()
			return
			
		#  Sets destruction texture of the tile
		var destruction_sprite = $Destruction
		var frame_count = destruction_sprite.sprite_frames.get_frame_count("default")
		destruction_sprite.frame = frame_count - int (float(health)/float(max_health) * frame_count)

func set_hardness(input):
	hardness = input

func set_tile_position(input):
	tile_position = input

func set_destroyability(input):
	destroyable = input

func get_hardness():
	return hardness

func get_tile_position():
	return tile_position
	
func get_destroy_signal():
	return destroyed

func get_drop_signal():
	return dropped

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

#  Destroy tile and remove it from the main tile dictionary
func destroy_tile():
	destroyed.emit(tile_position)
	dropped.emit(tile_position * 32, hardness, drop_type, $Sprite.sprite_frames.get_frame_texture($Sprite.animation, 0))
	queue_free()
