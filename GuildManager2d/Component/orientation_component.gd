extends Node2D

@export var sprite_handler : Node2D
@export var interaction_marker : Marker2D
@export var rotation_node_list : Array[Node2D]
@export var orientation_group_string : String

var position_offset = Vector2.ZERO
var collision_node_dictionary = {}
var current_collision_list = []
var last_orientation = 0

func _ready() -> void:
	add_rotation_objects()
	change_orientation_state(Utils.Orientation.SOUTH)

func add_rotation_objects():
	for node in rotation_node_list:
		if node:
			collision_node_dictionary[node] = {}
		for child in node.get_children():
			if child.is_in_group(orientation_group_string):
				collision_node_dictionary[node][child.name.to_lower()] = child
				child.disabled = true
				
func change_orientation_state(new_orientation):
	last_orientation = new_orientation
	var child_name = ""
	var pos_vec = Vector2.ZERO
	sprite_handler.rotate_sprite(new_orientation)
	position_offset = Vector2.ZERO
	match new_orientation:
		Utils.Orientation.SOUTH:
			child_name = "SOUTH"
			pos_vec = Vector2(0, 16)
			position_offset = Vector2(0, -16)
		Utils.Orientation.EAST:
			child_name = "EAST"
			pos_vec = Vector2(16, -16)
		Utils.Orientation.NORTH:
			child_name = "NORTH"
			pos_vec = Vector2(0, -32)
		Utils.Orientation.WEST:
			child_name = "WEST"
			pos_vec = Vector2(-16, -16)
	interaction_marker.position = pos_vec
	current_collision_list = []
	for key in collision_node_dictionary:
		var collision_dictionary = collision_node_dictionary[key] 
		for child_key in collision_dictionary:
			if child_key == child_name.to_lower():
				current_collision_list.append(collision_dictionary[child_key])
