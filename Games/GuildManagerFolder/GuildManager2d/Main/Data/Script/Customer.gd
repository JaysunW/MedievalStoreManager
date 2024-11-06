extends CharacterBody2D

@export var state_machine : Node2D

var npc_service_reference = null

var shopping_dictionary = {}
var shopping_time = 1

var state = Utils.NpcState.IDLE
var store_entry : Node2D

var entrance_marker : Marker2D

func change_state():
	state_machine.on_child_transition(state_machine.states["idle"], "walking")

func prepare_customer(reference):
	npc_service_reference = reference
	get_random_shopping_list()
	
func get_random_shopping_list():
	var item_data = Data.item_data
	var shopping_list_length = 3 + Global.rng.randi_range(0,4)
	var unlocked_id_list = []
	for id in item_data:
		if item_data[id]["unlocked"]:
			unlocked_id_list.append(id)
	for i in range(shopping_list_length):
		var random_id = unlocked_id_list.pick_random()
		if random_id in shopping_dictionary.keys():
			shopping_dictionary[random_id] += 1
		else:
			shopping_dictionary[random_id] = 1
