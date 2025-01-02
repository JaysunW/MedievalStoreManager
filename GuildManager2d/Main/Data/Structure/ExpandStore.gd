extends Node2D

@onready var wait_timer: Timer = $WaitTimer

@export var build_service : Node2D

@export var store_area : TileMapLayer
@export var store_ground : TileMapLayer
@export var store_building : TileMapLayer
@export var store_upper_building : TileMapLayer
@export var store_expansion_area : TileMapLayer

var next_expansion_price = 250

var is_expanding_store = false

func _ready() -> void:
	store_expansion_area.visible = false

func Enter():
	store_expansion_area.visible = true
	UI.open_expansion_UI.emit(next_expansion_price)
	wait_timer.start()

func Exit():
	is_expanding_store = false
	store_expansion_area.visible = false
	UI.open_expansion_UI.emit(0, false)
	build_service.child_exit()

func Process(_delta: float) -> void:
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
		if not Gold.pay(next_expansion_price):
			return
		store_building.remove_tile(mouse_tile_pos)
		store_upper_building.remove_tile(mouse_tile_pos + Vector2i.UP)
		var new_wall_position_list = []
		for y in range(-1,2):
			for x in range(-1,2):
				var vector_offset = Vector2i(x,y)
				if vector_offset != Vector2i.ZERO and store_expansion_area.is_area(mouse_tile_pos + vector_offset):
					new_wall_position_list.append(mouse_tile_pos + vector_offset)
		store_building.set_aligning_wall(new_wall_position_list)
		store_building.update_alignment_aroung(mouse_tile_pos, 5)
		store_ground.place_random_ground(mouse_tile_pos)
		store_area.set_build_area(mouse_tile_pos)
		store_expansion_area.remove_area(mouse_tile_pos)
		store_expansion_area.activate_expansion_area_around(mouse_tile_pos)
		build_service.update_navigation_region()
		
func _on_wait_timer_timeout() -> void:
	is_expanding_store = true
