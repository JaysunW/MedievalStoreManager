extends TileMapLayer

var last_building_dicitonary : Dictionary
var build_area_atlas = Vector2i(0,0)
var obstructed_area_atlas = Vector2i(1,0)
var buildable_area_atlas = Vector2i(2,0)
var building_space_area_atlas = Vector2i(3,0)

func is_in_shop_area(mouse_tile_pos):
	var atlas_coords = get_cell_atlas_coords(mouse_tile_pos)
	return atlas_coords != Vector2i(-1,-1)

func is_buildable_area(mouse_tile_pos, building):
	var space_vector_list = building.get_space_vector()
	for space_vector in space_vector_list:
		var tile_position = mouse_tile_pos + space_vector
		var tile_data = get_cell_tile_data(tile_position)
		var is_free = tile_data and tile_data.get_custom_data("is_building_area")
		if tile_position != mouse_tile_pos:
			is_free = tile_data and (tile_data.get_custom_data("is_building_area") or tile_data.get_custom_data("is_free_space"))
		if not is_free:
			return false
	return true

func show_building_area(mouse_tile_pos, building):
	for last_building_position in last_building_dicitonary:
		set_cell(last_building_position, 0, last_building_dicitonary[last_building_position])
	last_building_dicitonary = {}
	
	if not is_in_shop_area(mouse_tile_pos):
		building.change_color(Color.FIREBRICK)
		return
	
	var change_atlas = Vector2i.ZERO
	if not is_buildable_area(mouse_tile_pos, building):
		building.change_color(Color.FIREBRICK)
		change_atlas = obstructed_area_atlas
	else:
		building.change_color(Color.WHITE)
		change_atlas = buildable_area_atlas
	
	var space_vector_list = building.get_space_vector()
	for space_vector in space_vector_list:
		var tile_position = mouse_tile_pos + space_vector
		if is_in_shop_area(tile_position):
			last_building_dicitonary[tile_position] = get_cell_atlas_coords(tile_position)
			set_cell(tile_position, 0, change_atlas)

func place_object_at(mouse_tile_pos, building):
	last_building_dicitonary = {}
	var space_vector_list = building.get_space_vector()
	for space_vector in space_vector_list:
		var tile_position = mouse_tile_pos + space_vector
		if tile_position != mouse_tile_pos:
			set_cell(tile_position, 0, building_space_area_atlas)
		else:
			set_cell(tile_position, 0, obstructed_area_atlas)
