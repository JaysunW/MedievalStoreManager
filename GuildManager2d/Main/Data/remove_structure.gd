extends Node2D

@export var build_service : Node2D
@export var store_area : TileMapLayer

var last_position : Vector2i = Vector2i.ZERO
var last_object = null

func Enter():
	pass

func Exit():
	if last_object:
		last_object.change_color(Color.WHITE, true)
	last_position = Vector2i.ZERO
	last_object = null
	build_service.child_exit()

func Process(_delta: float) -> void:
	if Input.is_action_pressed("right_mouse"):
		Exit()
		return
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_area.local_to_map(mouse_pos)
	var object = build_service.world_map.get_object_at(mouse_tile_pos)
	if last_position != mouse_tile_pos:
		last_position = mouse_tile_pos
		if last_object:
			last_object.change_color(Color.WHITE, true)
		last_object = object
	if not object:
		return
	
	object.change_color(Color(0.7,0.2,0.2,0.5), true)
		
	if Input.is_action_pressed("left_mouse"):
		var size_list = object.get_size_list()
		var space_list = object.get_space_list()
		for pos in space_list:
			if pos in size_list:
				store_area.set_build_area(object.main_pos + pos)
			else:
				var should_remove = build_service.world_map.remove_from_space_dict(object.main_pos + pos)
				if should_remove:
					store_area.set_build_area(object.main_pos + pos)
		object.sell()
		last_object = null
		build_service.update_navigation_region()
