extends Node2D

@onready var build_menu = $"../BuildMenu"

@export var tile_node : TileMap
@export var placement_color = [Color(1,1,1,0.8), Color(1,0.4,0.4,1)]
@export var stand_scenes : Dictionary
@export var building = false

var current_build_name = null
var current_build_object = null

var in_build_area = false
var object_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_build_mode(building)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("y") and not building:
		change_build_mode(not building)
#	if Input.is_action_just_pressed("x"):
#		if object:
#			object.rotate_object()
	
	
	if building:
		var mouse_pos = get_global_mouse_position()
		var mouse_grid_pos = Vector2(int(mouse_pos.x) - (int(mouse_pos.x) % 32) + 16, 
								int(mouse_pos.y) - (int(mouse_pos.y) % 32) + 32)
		current_build_object.position = mouse_grid_pos
	
		if in_build_area and mouse_grid_pos not in object_dict.keys():
			current_build_object.change_color(placement_color[0])
		else:
			current_build_object.change_color(placement_color[1])
		
		if in_build_area and Input.is_action_pressed("left_mouse"):
			if mouse_grid_pos not in object_dict.keys():
				print("build")
				current_build_object.prepare_stand()
				object_dict[mouse_grid_pos] = current_build_object
				create_placeable_object()
		if Input.is_action_pressed("right_mouse"):
			print_debug("return build menu!!")
		#		if object:
		#			object.queue_free()
		#			object = null
		
func create_placeable_object():
	current_build_object = stand_scenes[current_build_name].instantiate()
	current_build_object.tile_map_reference = tile_node
	tile_node.add_child(current_build_object)
	
func change_build_mode(input):
#	building = input
	$BuildArea.visible = input
	build_menu.visible = input
#	
	
func _on_area_2d_mouse_entered():
	in_build_area = true
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	in_build_area = false
	pass # Replace with function body.


func _on_build_menu_chose_building_option(input):
	current_build_name = input
	create_placeable_object()
	building = true
