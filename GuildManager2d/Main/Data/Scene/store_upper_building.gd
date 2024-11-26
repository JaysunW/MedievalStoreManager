extends TileMapLayer

var auto_tiling_dictionary = {
	[2,0,2,0,0,2,2,2] : Vector2i( 0, 0),
	[2,0,2,1,0,2,2,2] : Vector2i( 3, 0),
	[2,0,2,0,1,2,2,2] : Vector2i( 1, 0),
	[2,0,2,1,1,2,2,2] : Vector2i( 2, 0),
}
	
func set_upper_building( wall_position, bitmap):
	var upper_building_atlas = get_auto_tiling_atlas(bitmap)
	set_cell(wall_position + Vector2i.UP, 0, upper_building_atlas)

func get_auto_tiling_atlas(bitmap):
	for key in auto_tiling_dictionary:
		var is_match = true
		for i in range(len(bitmap)):
			if not (key[i] == 2 or bitmap[i] == key[i]):
				is_match = false
		if is_match:
			return auto_tiling_dictionary[key]
	return Vector2i(-1,-1)
