extends Node2D

@export var ui_build_menu : CanvasLayer
@export var world_map : TileMap
@export var build_map : TileMap
@export var placement_color = [Color(1,1,1,0.8), Color(1,0.4,0.4,1)]
@export var stand_scenes : Dictionary

var mouse_grid_offset = Vector2i(16,16)
var is_build_menu_open = false
var is_building = false

var current_build_data = {}
var current_build_object = null

var in_build_area = false
var object_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_build_menu.visible = false
	build_map.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("right_mouse") and not is_building:
		if UI.is_ui_free():
			change_build_mode(true)
		elif is_build_menu_open:
			change_build_mode(false)
			
	if is_build_menu_open:
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos : Vector2i = build_map.local_to_map(mouse_pos)
		var mouse_grid_pos = tile_mouse_pos * 32 + mouse_grid_offset
		var tile_data : TileData = build_map.get_cell_tile_data(1, tile_mouse_pos)
		if tile_data and tile_data.get_custom_data("is_building_area"):
			if current_build_object:
				current_build_object.change_color(Color.WHITE)
			in_build_area = true
		else:
			if current_build_object:
				current_build_object.change_color(Color.FIREBRICK)
			in_build_area = false
			
		if is_building:
			current_build_object.position = mouse_grid_pos
			if in_build_area:
				if Input.is_action_pressed("left_mouse"):
					if mouse_grid_pos not in object_dict.keys() and Gold.pay(current_build_object.data["value"]):
						current_build_object.prepare_stand()
						object_dict[mouse_grid_pos] = current_build_object
						build_map.set_cell(1, tile_mouse_pos, 0, Vector2i(1,0))
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
