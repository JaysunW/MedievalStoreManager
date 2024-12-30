extends Node2D

@onready var wait_timer: Timer = $WaitTimer

@export var build_service : Node2D
@export var world_map : Node2D
@export var store_area : TileMapLayer

@export_group("Debug")
@export var debug = false
@export var debug_marker : Marker2D
@export var debug_stand_name : String

var mouse_grid_offset = Vector2i(16,32)
var is_build_menu_open = false

var current_build_data = {}
var current_build_object = null

var in_build_area = false
var can_build = false

func _ready():
	if debug:
		spawn_debug_shelf()

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
		current_build_object.queue_free()
		current_build_object = null
	current_build_data = null
	build_service.child_exit()
	
func _process(_delta):
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

	showing_buildable_area(mouse_tile_pos)
	current_build_object.position = mouse_grid_pos + Vector2i(current_build_object.get_position_offset())
	build_objects(mouse_tile_pos)

func showing_buildable_area(mouse_tile_pos):
	in_build_area = store_area.is_buildable_area(mouse_tile_pos, current_build_object)
	store_area.show_building_area(mouse_tile_pos, current_build_object)
	
func build_objects(mouse_tile_pos):
	if not can_build or not in_build_area:
		return 
	if Input.is_action_pressed("left_mouse"):
		if mouse_tile_pos not in world_map.object_dict.keys() and Gold.pay(current_build_object.data["value"]):
			current_build_object.prepare_structure()
			world_map.object_dict[mouse_tile_pos] = current_build_object
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
	current_build_object.position = tile_mouse_pos * 32 + mouse_grid_offset
	world_map.add_child(current_build_object)
	current_build_object.prepare_structure(false)
	current_build_object.data = current_build_data
	current_build_object.tile_layer_ref = world_map
	
func spawn_debug_shelf():
	var build_resource = Loader.load_structure_resource(debug_stand_name)
	if not build_resource:
		print_debug("Error while building")
		return
	var debug_stand = build_resource.instantiate()
	var tile_pos : Vector2i = store_area.local_to_map(debug_marker.global_position)
	var grid_tile_pos = tile_pos * 32 + mouse_grid_offset
	debug_stand.position = grid_tile_pos + Vector2i(0, -16)
	world_map.add_child(debug_stand)
	var structure_data = Data.shelving_structure_data
	for id in structure_data:
		if structure_data[id]["name"] == debug_stand_name:
			debug_stand.data = structure_data[id]
	debug_stand.tile_layer_ref = world_map
	debug_stand.prepare_structure(true)
	world_map.object_dict[tile_pos] = current_build_object
	store_area.set_cell(tile_pos, 0, Vector2i(1,0))
	
func _on_wait_timer_timeout() -> void:
	can_build = true
