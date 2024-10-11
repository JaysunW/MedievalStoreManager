extends Node2D

@export var interactionComponent : Area2D 
@export var player :CharacterBody2D

var object_distance = Vector2(20,20)
var is_holding_object = false
var held_object = null
var last_move_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player_velocity = player.velocity
	if player_velocity.x != 0 or player_velocity.y != 0:
		last_move_direction = player_velocity.normalized()
	interactionComponent.look_at(to_global(last_move_direction))
	if not is_holding_object:
			if Input.is_action_just_pressed("v"):
				try_take_object()
	else:
		held_object.position = player.global_position + object_distance * last_move_direction
		if Input.is_action_just_pressed("v"):
			drop_object()
	
func try_take_object():
	var objects = interactionComponent.get_interactable_object()
	var sorted_objects = {}
	for object in objects:
		if object.is_in_group("Content"):
			if sorted_objects.has("Content"):
				sorted_objects["Content"] += [object]
			else:
				sorted_objects["Content"] = [object]
		elif object.is_in_group("Stand"):
			if sorted_objects.has("Stand"):
				sorted_objects["Stand"] += [object]
			else:
				sorted_objects["Stand"] = [object]
	print_debug(sorted_objects)
	if sorted_objects.has("Content"):
		var object = sorted_objects["Content"].pick_random()
		is_holding_object = true
		held_object = object.get_main_object()
		held_object.change_hold_mode(true)
		print_debug("Success: ", object)
	elif sorted_objects.has("Content"):
		print_debug("Tried interacting with stand, is holding: ", is_holding_object)
	else:
		print_debug("Fail")

func drop_object():
	is_holding_object = false
	held_object.position = player.global_position + object_distance * last_move_direction + Vector2(0, 8)
	held_object.change_hold_mode(false)
