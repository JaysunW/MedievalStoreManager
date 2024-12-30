extends Node2D

@export var stand_info_ui : CanvasLayer
@export var interaction_component : Area2D 
@export var move_component : Node2D

@onready var interact_timer = $"../InteractTimer"

var last_move_direction = Vector2.ZERO
var object_distance = Vector2(20,20)
var held_object_offset = Vector2(0,0)

var is_holding_object = false
var held_object = null

var restrict_interact = false

func _ready() -> void:
	SignalService.restrict_player_interaction.connect(set_interaction)
	
func set_interaction(input):
	restrict_interact = input

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	last_move_direction = move_component.last_move_direction.normalized()
	interaction_component.look_at(to_global(last_move_direction))
	if is_holding_object:
		var target_position = global_position + object_distance * last_move_direction + held_object_offset
		var dif_vec = target_position - held_object.position
		held_object.position += dif_vec.normalized() * dif_vec.length() * 20 * _delta
	
	if restrict_interact:
		return
		
	if Input.is_action_just_pressed("q"):
		take_from_shelf()
	if not is_holding_object:
		if Input.is_action_just_pressed("e"):
			interact_with_object()
		if Input.is_action_pressed("e"):
			work_checkout()
	else:
		if Input.is_action_just_pressed("e"):
			held_object_and_interact()

func interact_with_object():
	var objects = interaction_component.get_interactable_object()
	var found_package_list = []
	var found_stand_list = []
	var found_interface_list = []
	for object in objects:
		if object.is_in_group("Content"):
			found_package_list.append(object.get_main_object())
		elif object.is_in_group("Stand"):
			found_stand_list.append(object.get_main_object())
		elif object.is_in_group("Interface"):
			found_interface_list.append(object.get_main_object())
	if not found_package_list.is_empty():
		hold_object(find_nearest_object(found_package_list))
	elif not found_interface_list.is_empty():
		var nearest_interface = find_nearest_object(found_interface_list)
		nearest_interface.interact()
	elif not found_stand_list.is_empty():
		var filled_stand_list = []
		for stand in found_stand_list:
			if not stand.is_empty():
				filled_stand_list.append(stand)
		if not filled_stand_list.is_empty():
			if UI.get_set_ui_free():
				var nearest_stand = find_nearest_object(filled_stand_list)
				UI.open_stand_info_UI.emit(nearest_stand)

func work_checkout():
	var objects = interaction_component.get_interactable_object()
	var found_checkout_list = []
	for object in objects:
		if object.is_in_group("Checkout"):
			found_checkout_list.append(object.get_main_object())
	if not found_checkout_list.is_empty():
		find_nearest_object(found_checkout_list).work_on_queue()
	
func take_from_shelf():
	if interact_timer.is_stopped():
		var objects = interaction_component.get_interactable_object()
		var found_stand_list = []
		for object in objects:
			if object.is_in_group("Stand"):
				found_stand_list.append(object.get_main_object())
		if found_stand_list.is_empty():
			return
		var filled_shelf_list = []
		for stand in found_stand_list:
			if not stand.is_empty():
				filled_shelf_list.append(stand)
		if filled_shelf_list.is_empty():
			return
		var stand = find_nearest_object(filled_shelf_list)
		if not held_object:
			var new_object = stand.get_content_instance()
			new_object.data["amount"] = 1
			hold_object(new_object)
			interact_timer.start()
			stand.take_from_shelf()
		elif held_object.data["id"] == stand.get_content_data()["id"] and held_object.data["amount"] < held_object.data["carry_max"]:
			stand.take_from_shelf()
			held_object.data["amount"] += 1
			UI.picked_up_package.emit(held_object.data, true)
			interact_timer.start()
		else:
			UI.flash_held_object.emit(Color.FIREBRICK)
			
func held_object_and_interact():
	var objects = interaction_component.get_interactable_object()
	var found_stand_list = []
	for object in objects:
		if object.is_in_group("Stand"):
			found_stand_list.append(object.get_main_object())
	if not found_stand_list.is_empty():
		fill_shelf(found_stand_list)
	else:
		drop_object()
	
func fill_shelf(found_stand_list):
	if interact_timer.is_stopped():
		var stand = find_nearest_object(found_stand_list)
		var filled_stand = stand.fill_shelf(held_object,)
		if filled_stand:
			interact_timer.start()
			held_object.data["amount"] -= 1
			if held_object.data["amount"] <= 0:
				drop_object(false)
			else:
				UI.picked_up_package.emit(held_object.data, true)
				
func hold_object(object):
	is_holding_object = true
	held_object = object
	UI.picked_up_package.emit(held_object.data, true)
	object.change_hold_mode(true)

func drop_object(is_not_stored=true):
	is_holding_object = false
	held_object.position = global_position + object_distance * last_move_direction + Vector2(0,8)
	held_object.change_hold_mode(false)
	UI.picked_up_package.emit({}, false)
	if is_not_stored:
		held_object = null
	else:
		held_object.queue_free()
		
func find_nearest_object(object_list):
	var smallest_distance = 100
	var nearest_object = null
	for object in object_list:
		var distance_to_player = (object.global_position - self.global_position).length()
		if smallest_distance > distance_to_player:
			smallest_distance = distance_to_player
			nearest_object = object
	return nearest_object

func _on_fill_shelf_timer_timeout():
	if Input.is_action_pressed("e"):
		if is_holding_object:
			held_object_and_interact()
	if Input.is_action_pressed("q"):
		take_from_shelf()
