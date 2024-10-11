extends Node2D

@export var interactionComponent : Area2D 
@export var moveComponent : Node2D

var last_move_direction = Vector2.ZERO
var object_distance = Vector2(20,20)
var held_object_offset = Vector2(0,8)

var is_holding_object = false
var held_object = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	last_move_direction = moveComponent.last_move_direction.normalized()
	interactionComponent.look_at(to_global(last_move_direction))
	if not is_holding_object:
		if Input.is_action_just_pressed("v"):
			interact_with_object()
	else:
		held_object.position = global_position + object_distance * last_move_direction + held_object_offset
		if Input.is_action_just_pressed("v"):
			interact_with_held_object()
		

func interact_with_object():
	var objects = interactionComponent.get_interactable_object()
	var sorted_objects = {}
	for object in objects:
		if object.is_in_group("Content"):
			if sorted_objects.has(Utils.ObjectType.CONTENT):
				sorted_objects[Utils.ObjectType.CONTENT] += [object.get_main_object()]
			else:
				sorted_objects[Utils.ObjectType.CONTENT] = [object.get_main_object()]
		elif object.is_in_group("Stand"):
			if sorted_objects.has(Utils.ObjectType.STAND):
				sorted_objects[Utils.ObjectType.STAND] += [object.get_main_object()]
			else:
				sorted_objects[Utils.ObjectType.STAND] = [object.get_main_object()]
	if Utils.ObjectType.CONTENT in sorted_objects.keys():
		take_package(sorted_objects[Utils.ObjectType.CONTENT])
	elif Utils.ObjectType.STAND in sorted_objects.keys():
		take_from_shelf(sorted_objects[Utils.ObjectType.STAND])
	else:
		print_debug("No interaction possible")
		
func take_from_shelf(found_stands):
	var filled_shelf_list = []
	for stand in found_stands:
		if not stand.is_empty():
			filled_shelf_list.append(stand)
	if not filled_shelf_list.is_empty():
		is_holding_object = true
		var stand = find_nearest_object(filled_shelf_list)
		held_object = stand.take_content()
		held_object.change_hold_mode(true)
	
func take_package(found_object_list):
	is_holding_object = true
	held_object = find_nearest_object(found_object_list)
	held_object.change_hold_mode(true)
	
func interact_with_held_object():
	var objects = interactionComponent.get_interactable_object()
	var found_objects = []
	for object in objects:
		if object.is_in_group("Stand"):
			found_objects.append(object.get_main_object())
	if not found_objects.is_empty():
		fill_shelf(found_objects)
	else:
		drop_object()
	
func fill_shelf(found_stands):
	var empty_stand_list = []
	for stand in found_stands:
		if stand.is_empty():
			empty_stand_list.append(stand)
	if not empty_stand_list.is_empty():
		is_holding_object = false
		var stand = find_nearest_object(empty_stand_list)
		stand.set_content(held_object)
		held_object = null
	
func drop_object():
	is_holding_object = false
	held_object.position = global_position + object_distance * last_move_direction + Vector2(0, 16)
	held_object.change_hold_mode(false)
	held_object = null

func find_nearest_object(object_list):
	var smallest_distance = 100
	var nearest_object = null
	for object in object_list:
		var distance_to_player = (object.global_position - self.global_position).length()
		if smallest_distance > distance_to_player:
			smallest_distance = distance_to_player
			nearest_object = object
	return nearest_object
