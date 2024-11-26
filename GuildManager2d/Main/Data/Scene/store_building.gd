extends TileMapLayer

@export var store_upper_building : TileMapLayer

var building_auto_tiling_dictionary = {
	[2,1,2,1,1,2,0,2] : Vector2i( 2, 1),
	[2,1,2,1,0,2,1,2] : Vector2i( 0, 1),
	[2,0,2,1,1,2,1,2] : Vector2i( 0, 1),
	[2,1,2,0,1,2,1,2] : Vector2i( 0, 1),
	
	[2,0,2,1,0,2,1,1] : Vector2i( 3, 2),
	[2,0,2,0,1,1,2,2] : Vector2i( 4, 2),
	
	[2,2,2,0,0,1,1,0] : Vector2i( 2, 2),
	[2,2,2,0,0,0,1,1] : Vector2i( 1, 2),
	
	[2,1,2,1,0,2,0,2] : Vector2i( 3, 1),
	[2,1,2,0,1,2,0,2] : Vector2i( 1, 1),
	[2,0,2,0,1,2,1,2] : Vector2i( 1, 3),
	[2,0,2,1,0,2,1,2] : Vector2i( 2, 3),
	
	[2,0,2,1,1,2,0,2] : Vector2i( 2, 1),
	[2,1,2,0,0,2,1,2] : Vector2i( 0, 1),
	
	[2,1,2,0,0,2,0,2] : Vector2i( 0, 2),
	[2,0,2,1,0,2,0,2] : Vector2i( 3, 1),
	[2,0,2,0,1,2,0,2] : Vector2i( 1, 1),
	[2,0,2,0,0,2,1,2] : Vector2i( 0, 1),
	[2,0,2,0,0,2,0,2] : Vector2i( 0, 2)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_aligning_wall(new_wall_position_list):
	for wall_position in new_wall_position_list:
		var bitmap = Global.get_bitmap(self, wall_position, new_wall_position_list)
		store_upper_building.set_upper_building(wall_position, bitmap)
		var wall_atlas = get_auto_tileing_atlas(bitmap)
		set_cell(wall_position, 0, wall_atlas)
		
func get_auto_tileing_atlas(bitmap):
	for key in building_auto_tiling_dictionary:
		var is_match = true
		for i in range(len(bitmap)):
			if not (key[i] == 2 or bitmap[i] == key[i]):
				is_match = false
		if is_match:
			return building_auto_tiling_dictionary[key]
	print_debug("No match found")
	return Vector2i.ZERO

func remove_building(mouse_tile_pos):
	set_cell(mouse_tile_pos, -1)