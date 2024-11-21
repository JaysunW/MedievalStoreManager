extends Node2D

@export var store_ground : TileMapLayer
@export var store_builing : TileMapLayer
@export var store_expansion_area : TileMapLayer

var is_expanding_store = false

func _process(delta: float) -> void:
	if not is_expanding_store:
		return
	
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_expansion_area.local_to_map(mouse_pos)
	
