extends Node

var rng = RandomNumberGenerator.new()

func get_bitmap(tile_layer, tile_position, added_tile_list = []):
	var bitmap = []
	for y in range(-1, 2):
		for x in range(-1, 2):
			var offset_vector = Vector2i(x,y)
			if offset_vector != Vector2i.ZERO:
				var new_wall_position = tile_position + offset_vector
				var atlas = tile_layer.get_cell_atlas_coords(new_wall_position)
				bitmap.append( int(atlas != Vector2i(-1,-1) or new_wall_position in added_tile_list))
	return bitmap

func is_license_unlocked(license_list: Array):
	var unlocked_licenses = Data.player_data["license"]
	return is_subset(license_list, unlocked_licenses)

func is_subset(list_a: Array, list_b: Array) -> bool:
	for item in list_a:
		if item not in list_b:
			return false	
	return true

func random_rotation_offset(orientation):
	if orientation == Utils.Orientation.SOUTH || orientation == Utils.Orientation.NORTH:
		return Vector2(rng.randf_range(-16, 17), rng.randf_range(-4, 4))
	elif orientation == Utils.Orientation.EAST || orientation == Utils.Orientation.WEST:
		return Vector2(rng.randf_range(-4, 4), rng.randf_range(-16, 17))
	return Vector2.ZERO
