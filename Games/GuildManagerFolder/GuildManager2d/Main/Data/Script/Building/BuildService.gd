extends Node2D

@export var ui_build_menu : CanvasLayer
@export var world_map : TileMap
@export var build_map : TileMap
@export var placement_color = [Color(1,1,1,0.8), Color(1,0.4,0.4,1)]
@export var stand_scenes : Dictionary

@export var debug = false
@export var debug_marker : Marker2D
@export var debug_stand_name : String

var mouse_grid_offset = Vector2i(16,16)
var is_build_menu_open = false
var is_building = false

var current_build_data = {}
var current_build_object = null

var in_build_area = false

func _ready():
	ui_build_menu.visible = false
	build_map.visible = false
	if debug:
		spawn_debug_shelf()
	pass # Replace with function body.

func spawn_debug_shelf():
	var debug_stand = stand_scenes[debug_stand_name].instantiate()
	var tile_pos : Vector2i = build_map.local_to_map(debug_marker.global_position)
	var grid_tile_pos = tile_pos * 32 + mouse_grid_offset
	debug_stand.position = grid_tile_pos + Vector2i(0, -8)
	world_map.add_child(debug_stand)
	var build_data = Data.building_data
	for data in build_data:
		if build_data[data]["name"] == debug_stand_name:
			debug_stand.data = build_data[data]
	debug_stand.tile_map_reference = world_map
	world_map.object_dict[tile_pos] = current_build_object
	build_map.set_cell(1, tile_pos, 0, Vector2i(1,0))
	
func _process(_delta):
	if Input.is_action_just_pressed("right_mouse") and not is_building:
		if UI.is_ui_free():
			change_build_mode(true)
		elif is_build_menu_open:
			change_build_mode(false)
			
	if Input.is_action_just_pressed("c"):
		Stock.print_current_stock()		
	
	if not is_build_menu_open:
		return
		
	var mouse_pos = get_global_mouse_position() + Vector2( 0, 16)
	var mouse_tile_pos : Vector2i = build_map.local_to_map(mouse_pos)
	var mouse_grid_pos = mouse_tile_pos * 32 + mouse_grid_offset
	var tile_data : TileData = build_map.get_cell_tile_data(1, mouse_tile_pos)
	if tile_data and tile_data.get_custom_data("is_building_area"):
		if current_build_object:
			current_build_object.change_color(Color.WHITE)
		in_build_area = true
	else:
		if current_build_object:
			current_build_object.change_color(Color.FIREBRICK)
		in_build_area = false
		
	if not is_building:
		return 
		
	current_build_object.position = mouse_grid_pos
	if in_build_area:
		if Input.is_action_pressed("left_mouse"):
			if mouse_grid_pos not in world_map.object_dict.keys() and Gold.pay(current_build_object.data["value"]):
				current_build_object.prepare_stand()
				world_map.object_dict[mouse_grid_pos] = current_build_object
				build_map.set_cell(1, mouse_tile_pos, 0, Vector2i(1,0))
				create_placeable_object()
			else:
				current_build_object.flash_color(Color.FIREBRICK, 0.1)
	if Input.is_action_pressed("right_mouse"):
		if current_build_object:
			current_build_object.queue_free()
			current_build_object = null
		is_building = false
		ui_build_menu.visible = true
			
func create_placeable_object():
	current_build_object = stand_scenes[current_build_data["name"]].instantiate()
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos : Vector2i = build_map.local_to_map(mouse_pos)
	current_build_object.position = tile_mouse_pos * 32 + mouse_grid_offset
	world_map.add_child(current_build_object)
	current_build_object.data = current_build_data
	current_build_object.tile_map_reference = world_map
	
func change_build_mode(input):
	build_map.visible = input
	ui_build_menu.visible = input
	is_build_menu_open = input
	UI.is_free(not input)
	
func _on_build_menu_chose_building_option(stand_data):
	current_build_data = stand_data
	create_placeable_object()
	is_building = true
