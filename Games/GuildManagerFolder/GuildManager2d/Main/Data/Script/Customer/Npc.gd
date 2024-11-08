extends CharacterBody2D

@export var state_machine : Node2D

var npc_service_reference = null

var shopping_dictionary : Dictionary
var basket_items : Array

var speed = 12000

var patience = 6
var has_been_billed = false

func get_basket_items():
	return basket_items

func change_state():
	state_machine.on_child_transition(state_machine.states["idle"], "walking")

func prepare_customer(reference):
	npc_service_reference = reference
	
func get_random_shopping_list():
	shopping_dictionary = {0:4}
#	var item_data = Data.item_data
#	var shopping_list_length = 3 + Global.rng.randi_range(0,4)
#	var unlocked_id_list = []
#	for id in item_data:
#		if item_data[id]["unlocked"]:
#			unlocked_id_list.append(id)
#	for i in range(shopping_list_length):
#		var random_id = unlocked_id_list.pick_random()
#		if random_id in shopping_dictionary.keys():
#			shopping_dictionary[random_id] += 1
#		else:
#			shopping_dictionary[random_id] = 1
