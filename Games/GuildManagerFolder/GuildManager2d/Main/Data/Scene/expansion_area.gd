extends TileMapLayer

func is_expansion_area(mouse_tile_pos):
	var atlas_coords = get_cell_atlas_coords(mouse_tile_pos)
	return atlas_coords != Vector2i(-1,-1)
