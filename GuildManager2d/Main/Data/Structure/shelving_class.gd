extends StaticBody2D

@onready var interaction_object_component = $InteractionObjectComponent
@onready var orientation_component: Node2D = $OrientationComponent
@onready var sprite_handler: Node2D = $SpriteHandler

@export var package_scene : PackedScene
@export var interaction_marker : Marker2D
@export var tile_size = Vector2i(1, 1)

var data = {}
var content_data = {}

var tile_layer_ref : Node2D
var need_space = true
var current_orientation = Utils.Orientation.SOUTH

func prepare_structure(should_prepare=true):
	sprite_handler.should_prepare_building(should_prepare)
	for collision in orientation_component.current_collision_list:
		collision.set_deferred("disabled", not should_prepare)
	interaction_object_component.set_deferred("monitorable", should_prepare)

func get_space_vector():
	var space_vector_list = [Vector2i.ZERO]
	match current_orientation:
		Utils.Orientation.SOUTH:
			space_vector_list.append(Vector2i(0, 1))
		Utils.Orientation.WEST:
			space_vector_list.append(Vector2i(-1, 0))
		Utils.Orientation.NORTH:
			space_vector_list.append(Vector2i(0, -1))
		Utils.Orientation.EAST:
			space_vector_list.append(Vector2i(1, 0))
	return space_vector_list
	
func get_npc_interaction_position():
	return interaction_marker.global_position + Global.random_rotation_offset(orientation_component.current_orientation)

func get_position_offset():
	return orientation_component.position_offset

func get_content_data():
	content_data["value"] = Data.item_data[content_data["id"]]["value"]
	return content_data
	
func get_content_amount():
	if content_data.is_empty():
		return 0
	return content_data["amount"]

func rotate_object(new_orentation):
	current_orientation = posmod(current_orientation + new_orentation, 4)
	orientation_component.change_orientation_state(current_orientation)

func fill_shelf(content):
	var input_data = content.data.duplicate()
	if content_data.is_empty():
		content_data = input_data
		content_data["amount"] = 1
		sprite_handler.prepare_filling_building(content_data)
		Stock.add_to_stock(content_data["id"], self)
		return true
	elif content_data["id"] != input_data["id"]:
		flash_color(Color.FIREBRICK)
		return false
	content_data["amount"] += 1
	if content_data["amount"] > content_data["max_amount"]:
		content_data["amount"] = content_data["max_amount"]
		flash_color(Color.FIREBRICK)
		return false
	else:
		sprite_handler.show_filling_building(content_data)
		Stock.add_to_stock(content_data["id"], self)
		return true

func take_from_shelf():
	content_data["amount"] -= 1
	if content_data["amount"] <= 0:
		Stock.take_from_stock(content_data["id"], self, true)
		empty_content()
	else:
		#Depending on fill scale:
		sprite_handler.show_filling_building(content_data)
		Stock.take_from_stock(content_data["id"], self)
	
func get_content_instance():
	var content = package_scene.instantiate()
	content.data = get_content_data().duplicate()
	content.position = global_position
	tile_layer_ref.add_child(content)
	return content

func empty_content():
	if content_data.is_empty():
		print_debug("Error empied empty shelf")
	content_data = {}
	sprite_handler.is_being_emptied()

func is_empty():
	return content_data.is_empty()
	
func change_color(color, change_alpha=false):
	sprite_handler.change_color(color, change_alpha)
	
func flash_color(color, flash_time = 0.1, change_alpha = false):
	sprite_handler.flash_color(color, flash_time, change_alpha)
