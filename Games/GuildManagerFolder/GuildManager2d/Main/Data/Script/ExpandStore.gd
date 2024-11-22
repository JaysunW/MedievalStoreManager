extends Node2D

@export var build_service : Node2D

@export var store_area : TileMapLayer
@export var store_ground : TileMapLayer
@export var store_builing : TileMapLayer
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
		store_ground.place_random_ground(mouse_tile_pos)
		store_area.set_build_area_at(mouse_tile_pos)
		store_expansion_area.remove_area(mouse_tile_pos)
