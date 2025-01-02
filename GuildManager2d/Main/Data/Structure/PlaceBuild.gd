extends Node2D

@onready var wait_timer: Timer = $WaitTimer

@export var build_service : Node2D
@export var world_map : Node2D
@export var store_area : TileMapLayer

@export_group("Debug")
@export var debug = false
@export var debug_stand_marker : Marker2D
@export var debug_stand_name : String
@export var debug_store_marker : Marker2D
@export var debug_store_name : String

var mouse_grid_offset = Vector2i(16,48)
var is_build_menu_open = false

var current_build_data = {}
var current_build_object = null

var in_build_area = false
var can_build = false

func _ready():
	if debug:
		spawn_debug_object(debug_stand_name, debug_stand_marker)
		spawn_debug_object(debug_store_name, debug_store_marker)
		build_service.update_navigation_region()

func Enter(structure_data):
	store_area.visible = true
	can_build = false
	current_build_data = structure_data
	create_placeable_object()
	wait_timer.start()

func Exit():
	store_area.visible = false
	can_build = false
	if current_build_object:
		current_build_object.remove_object()
		current_build_object = null
	current_build_data = null
	build_service.child_exit()
	
func Process(_delta: float) -> void:
	if not current_build_object:
		return
	if Input.is_action_pressed("right_mouse"):
		Exit()
		return
	if Input.is_action_just_pressed("q"):
		current_build_object.rotate_object(-1)
	if Input.is_action_just_pressed("e"):
		current_build_object.rotate_object(1)	
	
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_area.local_to_map(mouse_pos)
	var mouse_grid_pos = mouse_tile_pos * 32 + mouse_grid_offset

	showing_buildable_area(mouse_tile_pos, current_build_object)
	current_build_object.position = mouse_grid_pos + Vector2i(current_build_object.get_position_offset())
	build_objects(mouse_tile_pos)

func showing_buildable_area(mouse_tile_pos, building):
	in_build_area = store_area.is_buildable_area(mouse_tile_pos, building)
	store_area.show_building_area(mouse_tile_pos, building)
	
func build_objects(mouse_tile_pos):
	if not can_build or not in_build_area:
		return 
	if Input.is_action_pressed("left_mouse"):
		if mouse_tile_pos not in world_map.object_dict.keys() and Gold.pay(current_build_object.data["value"]):
			current_build_object.prepare_structure()
			for pos in current_build_object.get_size_list():
				world_map.object_dict[mouse_tile_pos + pos] = current_build_object
			store_area.place_object_at(mouse_tile_pos, current_build_object)
			create_placeable_object()
			build_service.update_navigation_region()
		else:
			current_build_object.flash_color(Color.FIREBRICK, 0.1)
		
func create_placeable_object():
	var build_resource = Loader.load_structure_resource(current_build_data["name"])
	if not build_resource:
		print_debug("Error while building")
		return
	current_build_object = build_resource.instantiate()
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos : Vector2i = store_area.local_to_map(mouse_pos)
	world_map.add_to_world(current_build_object)
	current_build_object.global_position = tile_mouse_pos * 32 + mouse_grid_offset + Vector2i(current_build_object.get_position_offset())
	current_build_object.prepare_structure(false)
	current_build_object.data = current_build_data
	
func spawn_debug_object(debug_name, debug_marker):
	var build_resource = Loader.load_structure_resource(str(debug_name).to_lower())
	if not build_resource:
		print_debug("Error while building")
		return
	var debug_object = build_resource.instantiate()
	var tile_pos : Vector2i = store_area.local_to_map(debug_marker.global_position)
	showing_buildable_area(tile_pos, debug_object)
	world_map.add_to_world(debug_object)
	debug_object.prepare_structure()
	debug_object.global_position = tile_pos * 32 + mouse_grid_offset + Vector2i(debug_object.get_position_offset())
	var shelving_dic = Data.shelving_structure_data
	var store_dic = Data.store_structure_data
	for id in shelving_dic:
		if shelving_dic[id]["name"] == debug_stand_name:
			debug_object.data = shelving_dic[id]
	for id in store_dic:
		if store_dic[id]["name"] == debug_stand_name:
			debug_object.data = store_dic[id]
	for pos in debug_object.get_size_list():
		world_map.object_dict[tile_pos + pos] = debug_object
	store_area.place_object_at(tile_pos, debug_object)

	
func _on_wait_timer_timeout() -> void:
	can_build = true
