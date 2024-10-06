extends Node2D

@export var shelf_scene : PackedScene

var object = null
var building = true
var in_build_area = false
var object_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	create_placeable_object()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var mouse_grid_pos = Vector2(int(mouse_pos.x) - (int(mouse_pos.x) % 32) + 16, 
							int(mouse_pos.y) - (int(mouse_pos.y) % 32) + 16)
	if building:
		object.position = mouse_grid_pos
		
	if in_build_area and Input.is_action_pressed("left_mouse_button"):
		if mouse_grid_pos not in object_dict.keys():
			print("build")
			object_dict[mouse_grid_pos] = object
			create_placeable_object()
		else:
			print("couldn't build")
			
func create_placeable_object():
	object = shelf_scene.instantiate()
	add_child(object)
	

func _on_area_2d_mouse_entered():
	in_build_area = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	in_build_area = false
	pass # Replace with function body.
