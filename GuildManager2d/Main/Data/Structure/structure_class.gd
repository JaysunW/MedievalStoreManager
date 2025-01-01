extends Node2D
class_name StructureClass

@export var sprite_handler : Node2D
@export var orientation_component : Node2D
@export var interaction_object_component : Area2D
@export var needs_front_space = false
@export var size_list : Array[Vector2i]

var structure_data = {}

var current_orientation = Utils.Orientation.SOUTH

func prepare_structure(should_prepare=true):
	if not sprite_handler:
		return
	sprite_handler.should_prepare_building(should_prepare)
	for collision in orientation_component.current_collision_list:
		collision.set_deferred("disabled", not should_prepare)
	interaction_object_component.set_deferred("monitorable", should_prepare)

func rotate_object(new_orentation):
	if not orientation_component:
		return
	current_orientation = posmod(current_orientation + new_orentation, 4)
	orientation_component.change_orientation_state(current_orientation)

func get_size_list():
	return size_list

func get_space_list():
	if not needs_front_space:
		return size_list
	var output_list = []
	for pos_vector in size_list:
		match current_orientation:
			Utils.Orientation.SOUTH:
				if not pos_vector + Vector2i(0, 1) in size_list:
					output_list.append(pos_vector + Vector2i(0, 1))
			Utils.Orientation.WEST:
				if not pos_vector + Vector2i(-1, 0) in size_list:
					output_list.append(pos_vector + Vector2i(-1, 0))
			Utils.Orientation.NORTH:
				if not pos_vector + Vector2i(0, -1) in size_list:
					output_list.append(pos_vector + Vector2i(0, -1))
			Utils.Orientation.EAST:
				if not pos_vector + Vector2i(1, 0) in size_list:
					output_list.append(pos_vector + Vector2i(1, 0))
	return size_list + output_list

func get_position_offset():
	if not orientation_component:
		return Vector2.ZERO
	return orientation_component.position_offset
	
func change_color(color, change_alpha=false):
	if not sprite_handler:
		return
	sprite_handler.change_color(color, change_alpha)
	
func flash_color(color, flash_time = 0.1, change_alpha = false):
	if not sprite_handler:
		return
	sprite_handler.flash_color(color, flash_time, change_alpha)
