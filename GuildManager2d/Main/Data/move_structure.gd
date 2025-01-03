extends Node2D

@export var build_service : Node2D
@export var store_area : TileMapLayer

var last_position : Vector2i = Vector2i.ZERO
var last_object = null

var last_structure_position : Vector2i = Vector2i.ZERO
var held_structure = null

var in_build_area : bool = false

func Enter():
	pass

func Exit():
	if held_structure:
		pass
		#reset structure
	if last_object:
		last_object.prepare_structure()
	last_position = Vector2i.ZERO
	last_object = null
	last_structure_position = Vector2i.ZERO
	held_structure = null
	in_build_area = false
	build_service.child_exit()

func Process(_delta: float) -> void:
	if Input.is_action_pressed("right_mouse"):
		Exit()
		return
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_area.local_to_map(mouse_pos)
	var object = build_service.world_map.get_object_at(mouse_tile_pos)
	if not held_structure and last_position != mouse_tile_pos:
		last_position = mouse_tile_pos
		if last_object:
			last_object.prepare_structure()
		last_object = object

	if held_structure:
		if Input.is_action_just_pressed("q"):
			held_structure.rotate_object(-1)
		if Input.is_action_just_pressed("e"):
			held_structure.rotate_object(1)	
		showing_buildable_area(mouse_tile_pos, held_structure)
		held_structure.position = mouse_tile_pos * 32 + build_service.mouse_grid_offset + Vector2i(held_structure.get_position_offset())
		build_objects(mouse_tile_pos)
	
	if object:
		object.prepare_structure(false)
		
	if Input.is_action_just_pressed("left_mouse") and not held_structure and object:
		held_structure = object
		last_structure_position = mouse_tile_pos
		var size_list = object.get_size_list()
		var space_list = object.get_space_list()
		var main_pos = object.main_pos
		for pos in space_list:
			if pos in size_list:
				build_service.world_map.remove_structure(main_pos + pos)
				store_area.set_build_area(main_pos + pos)
			else:
				var should_remove = build_service.world_map.remove_from_space_dict(main_pos + pos)
				if should_remove:
					store_area.set_build_area(main_pos + pos)
		
func build_objects(mouse_tile_pos):
	if not in_build_area:
		return 
	if Input.is_action_just_pressed("left_mouse"):
		held_structure.set_stand_info(mouse_tile_pos)
		held_structure.prepare_structure()
		var size_list = held_structure.get_size_list()
		var space_list = held_structure.get_space_list()
		for pos in space_list:
			if pos in size_list:
				build_service.world_map.object_dict[mouse_tile_pos + pos] = held_structure
			else:
				build_service.world_map.add_to_space_dict(mouse_tile_pos + pos)
		store_area.place_object_at(mouse_tile_pos, held_structure)
		build_service.update_navigation_region()
		held_structure = null
	else:
		held_structure.flash_color(Color.FIREBRICK, 0.1)

func showing_buildable_area(mouse_tile_pos, building):
	in_build_area = store_area.is_buildable_area(mouse_tile_pos, building)
	store_area.show_building_area(mouse_tile_pos, building)
