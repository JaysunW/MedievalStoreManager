extends Node2D

@export var tile_node : TileMap
@export var shelf_scene : PackedScene
@export var building = false
@export var placement_color = [Color(1,1,1,0.8), Color(1,0.4,0.4,1)]

var object = null

var in_build_area = false
var object_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_build_mode(building)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("y"):
		change_build_mode(not building)
	if Input.is_action_just_pressed("x"):
		if object:
			object.rotate_object()
		
	if building:
		var mouse_pos = get_global_mouse_position()
		var mouse_grid_pos = Vector2(int(mouse_pos.x) - (int(mouse_pos.x) % 32) + 16, 
								int(mouse_pos.y) - (int(mouse_pos.y) % 32) + 32)
		object.position = mouse_grid_pos
	
		if in_build_area and mouse_grid_pos not in object_dict.keys():
			object.change_color(placement_color[0])
		else:
			object.change_color(placement_color[1])
		
		if in_build_area and Input.is_action_pressed("left_mouse_button"):
			if mouse_grid_pos not in object_dict.keys():
				print("build")
				object.prepare_stand()
				object_dict[mouse_grid_pos] = object
				create_placeable_object()
		
func create_placeable_object():
	object = shelf_scene.instantiate()
	tile_node.add_child(object)
	
func change_build_mode(input):
	building = input
	$BuildArea.visible = input
	if input:
		create_placeable_object()
	else:
		if object:
			object.queue_free()
			object = null
	
func _on_area_2d_mouse_entered():
	in_build_area = true
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	in_build_area = false
	pass # Replace with function body.
