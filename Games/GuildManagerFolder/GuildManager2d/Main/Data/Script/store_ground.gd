extends TileMapLayer

var store_ground_atlas = []

func _ready() -> void:
	for x in range(2):
		for y in range(3):
			store_ground_atlas.append(Vector2i(x, y))
			
func place_random_ground(mouse_tile_pos):
	var random_atlas = store_ground_atlas[Global.rng.randi_range(0, len(store_ground_atlas)-1)]
	set_cell(mouse_tile_pos, 0, random_atlas)
