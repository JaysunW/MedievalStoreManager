extends TileMapLayer

func _ready() -> void:
	visible = false

func is_expansion_area(mouse_tile_pos):
	var atlas_coords = get_cell_atlas_coords(mouse_tile_pos)
	return atlas_coords != Vector2i(-1,-1)

func remove_area(mouse_tile_pos):
	set_cell(mouse_tile_pos, -1)
	
func add_area(mouse_tile_pos):
	set_cell(mouse_tile_pos, 0, Vector2i(2,0))
