extends Node2D

@export var sprite_handler : Node2D
@export var interaction_marker : Marker2D
@export var rotation_node_list : Array[Node2D]

var position_offset = Vector2i.ZERO
var collision_node_dictionary = {}
var collision_start_position = {}
var current_collision_list = []
var current_orientation = 0

func _ready() -> void:
	add_rotation_objects()
	change_orientation_state(Utils.Orientation.SOUTH)

func add_rotation_objects():
	for node in rotation_node_list:
		if node:
			collision_node_dictionary[node] = {}
			collision_start_position[node] = {}
			for child in node.get_children():
				if child is CollisionShape2D:
					collision_node_dictionary[node][child.name.to_lower()] = child
					collision_start_position[node][child.name.to_lower()] = child.position
					child.disabled = true
				
func get_oriented_size_list(size_list) -> Array[Vector2i]:
	var output_list : Array[Vector2i] = []
	if current_orientation == Utils.Orientation.EAST or current_orientation == Utils.Orientation.EAST:
		for pos in size_list:
			output_list.append(Vector2i(pos.y, -pos.x))
	else:
		for pos in size_list:
			output_list.append(Vector2i(-pos.y, -pos.x))
		
		
	return output_list
			
func change_orientation_state(new_orientation, leave_side = false):
	current_orientation = new_orientation
	var child_name = ""
	var interaction_marker_offset = Vector2.ZERO
	var collision_offset = Vector2.ONE
	position_offset = Vector2i.ZERO
	sprite_handler.rotate_sprite(new_orientation)
	match new_orientation:
		Utils.Orientation.SOUTH:
			child_name = "Frontal"
			interaction_marker_offset = Vector2(0, 16)
			position_offset = Vector2i(0, -16)
		Utils.Orientation.EAST:
			child_name = "Side"
			interaction_marker_offset = Vector2(16, -16)
		Utils.Orientation.NORTH:
			child_name = "Frontal"
			interaction_marker_offset = Vector2(0, -32)
		Utils.Orientation.WEST:
			child_name = "Side"
			interaction_marker_offset = Vector2(-16, -16)
			if not leave_side:
				collision_offset = Vector2(-1, 1)
	interaction_marker.position = interaction_marker_offset
	current_collision_list = []
	for node in collision_node_dictionary:
		var collision_dictionary = collision_node_dictionary[node] 
		for child_key in collision_dictionary:
			var current_collision_object = collision_dictionary[child_key]
			if child_key == child_name.to_lower():
				current_collision_object.visible = true
				current_collision_object.position = collision_start_position[node][child_key] * collision_offset
				current_collision_list.append(collision_dictionary[child_key])
			else:
				current_collision_object.visible = false
