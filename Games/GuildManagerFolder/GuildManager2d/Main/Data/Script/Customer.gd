extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent

@export var target_object : Node2D
@export var target_position : Vector2
@export var shopping_dictionary = {}
@export var shopping_time = 1

const speed = 12000

var state = Utils.NpcState.IDLE
var store_entry : Node2D

func _physics_process(_delta):
	if target_object and not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - global_position).normalized()
		velocity = dir * speed * _delta
		move_and_slide()
		
func prepare_customer(target):
	get_random_shopping_list()
	set_target_object(target)
	
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
	
func set_target_object(input_object):
	target_object = input_object
	make_path()
	
func set_target_position(input_position):
	target_position = input_position
	make_path()
	
func make_path():
	navigation_agent.target_position = target_object.global_position
	print("t: ", target_object.global_position)
