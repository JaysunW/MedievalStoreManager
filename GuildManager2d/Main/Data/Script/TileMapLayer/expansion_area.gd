extends TileMapLayer

var end_expasion_area_atlas = Vector2i(1,0)
var expansion_area_atlas = Vector2i(2,0)
var next_expansion_atlas = Vector2i(3,0)

func _ready() -> void:
	visible = false

func is_area(mouse_tile_pos):
	var atlas_coordination = get_cell_atlas_coords(mouse_tile_pos)
	return atlas_coordination != Vector2i(-1,-1)
	
func is_expansion_area(mouse_tile_pos):
	var tile_data = get_cell_tile_data(mouse_tile_pos)
	return tile_data and tile_data.get_custom_data("is_expansion_area")

func is_next_expansion_area(mouse_tile_pos):
	var tile_data = get_cell_tile_data(mouse_tile_pos)
	return tile_data and tile_data.get_custom_data("is_next_area")

func is_end_expansion(mouse_tile_pos):
	var tile_data = get_cell_tile_data(mouse_tile_pos)
	return tile_data and tile_data.get_custom_data("end_expansion")

func remove_area(mouse_tile_pos):
	set_cell(mouse_tile_pos, -1)
	
func add_area(mouse_tile_pos):
	set_cell(mouse_tile_pos, 0, Vector2i(2,0))

func activate_expansion_area_around(mouse_tile_pos):
	var surrounding_position_list = get_surrounding_cells(mouse_tile_pos)
	for neighbour_position in surrounding_position_list:
		if is_end_expansion(neighbour_position):
			set_cell(neighbour_position, 0, end_expasion_area_atlas)
		elif is_area(neighbour_position):
			set_cell(neighbour_position, 0, expansion_area_atlas)
