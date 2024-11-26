extends Node2D

@export var build_service : Node2D

@export var store_area : TileMapLayer
@export var store_ground : TileMapLayer
@export var store_building : TileMapLayer
@export var store_upper_building : TileMapLayer
@export var store_expansion_area : TileMapLayer

var is_expanding_store = false

func _ready() -> void:
	store_expansion_area.visible = false

func Enter():
	is_expanding_store = true
	store_expansion_area.visible = true

func Exit():
	is_expanding_store = false
	store_expansion_area.visible = false
	build_service.child_exit()

func _process(_delta: float) -> void:
	if not is_expanding_store:
		return
	
	if Input.is_action_just_pressed("right_mouse"):
		Exit()
		return
		
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_expansion_area.local_to_map(mouse_pos)
	if Input.is_action_just_pressed("left_mouse"):
		if not store_expansion_area.is_expansion_area(mouse_tile_pos):
			return
		store_building.remove_building(mouse_tile_pos)
		var new_wall_position_list = []
		for y in range(-1,2):
			for x in range(-1,2):
				var vector_offset = Vector2i(x,y)
				if vector_offset != Vector2i.ZERO and store_expansion_area.is_area(mouse_tile_pos + vector_offset):
					new_wall_position_list.append(mouse_tile_pos + vector_offset)
		store_building.set_aligning_wall(new_wall_position_list)
		store_ground.place_random_ground(mouse_tile_pos)
		store_area.set_build_area(mouse_tile_pos)
		store_expansion_area.remove_area(mouse_tile_pos)
		store_expansion_area.activate_expansion_area_around(mouse_tile_pos)
		
