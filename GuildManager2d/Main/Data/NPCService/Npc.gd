extends CharacterBody2D

@export var animation_component : Node2D
@export var state_machine : Node2D

@export var id = 0

var npc_service_reference = null

var shopping_dictionary : Dictionary
var basket_list : Array

var speed = 12000

var patience = 6
var has_been_billed = false

func get_basket_list():
	return basket_list

func bought_basket():
	has_been_billed = true
	basket_list = []

func change_state(new_id):
	id = new_id
	state_machine.on_child_transition(state_machine.states["idle"], "walking")

func prepare_customer(reference):
	npc_service_reference = reference
	var col = [Global.rng.randf_range(0,1),Global.rng.randf_range(0,1),Global.rng.randf_range(0,1)]
	if (col[0] + col[1] + col[2]) < 0.2:
		var minpos = col.find(col.min())
		col[minpos] += 0.2
	animation_component.cloth_color = Color(col[0], col[1], col[2])
	
func get_random_shopping_list():
	shopping_dictionary = {7:4}
#	var item_data = Data.item_data
#	var shopping_list_length = 3 + Global.rng.randi_range(0,4)
#	var unlocked_id_list = []
#	for id in item_data:
		#change whether the item was unlocked with Global!
#		if item_data[id]["unlocked"]:
#			unlocked_id_list.append(id)
#	for i in range(shopping_list_length):
#		var random_id = unlocked_id_list.pick_random()
#		if random_id in shopping_dictionary.keys():
#			shopping_dictionary[random_id] += 1
#		else:
#			shopping_dictionary[random_id] = 1

func change_animation(move_direction):
	if not move_direction:
		animation_component.set_animation("default")
		return 
	
	if not abs(move_direction.y) > abs(move_direction.x):
		animation_component.set_animation("walking_horizontal")
		animation_component.set_flip_h(move_direction.x < 0)
		return 
	
	if move_direction.y > 0:
		animation_component.set_animation("walking")
	else:
		animation_component.set_animation("walking_back")
