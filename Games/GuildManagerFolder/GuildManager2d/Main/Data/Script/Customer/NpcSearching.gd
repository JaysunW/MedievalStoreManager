extends State

const speed = 12000

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

@onready var wait_timer = $WaitTimer
@onready var interact_timer = $InteractTimer

var shopping_dictionary : Dictionary
var poi_list : Array[Marker2D]

var current_search_id : int
var current_search_stand = null
var found_item_list : Array

var searching_for_item = true
var in_interact_cooldown = false

func _ready():
	poi_list = customer.npc_service_reference.poi_list
	wait_timer.wait_time = Global.rng.randf_range(2, 4)

func Enter():
	var stock_stand_list = Stock.stock_stand_list
	shopping_dictionary = customer.shopping_dictionary
	print("Stand_list: ",stock_stand_list)
	print("Shopping: ", shopping_dictionary)
	var id_list = shopping_dictionary.keys()
	
	if not id_list:
		if found_item_list:
			print("Found item go to checkout")
			print("Found_item_list: ", found_item_list)
		else:
			transitioned.emit(self, "idle")
		return 
		
	current_search_id = id_list.pick_random()
	print("Current_id: ", current_search_id)
	if current_search_id in stock_stand_list:
		var stand_list_with_search_item = stock_stand_list[current_search_id]
		current_search_stand = stand_list_with_search_item.pick_random()
		target_position = current_search_stand.get_npc_interaction_position()
		searching_for_item = false
		make_path()
	else:
		shopping_dictionary.erase(current_search_id)
		wait_timer.start()
		wait_timer.wait_time = Global.rng.randf_range(2, 4)
		print("Couldn't find item with id: ", current_search_id)
		
func Update(_delta):
	if navigation_agent.is_navigation_finished():
		if searching_for_item or in_interact_cooldown:
			print("on interation cooldown or waiting for search")
			return 
		if not current_search_stand or current_search_stand.is_empty():
			print("current_stand empty or not there")
			searching_for_item = true
			Enter()
			return
		
		if current_search_stand.get_content_data()["id"] == current_search_id:
			in_interact_cooldown = true
			interact_timer.start()
			
			# Decide whether to buy it or not!
			
			var stand_content = current_search_stand.get_content_data().duplicate()
			stand_content["amount"] = 1
			found_item_list.append(stand_content)
			current_search_stand.take_from_shelf()
			shopping_dictionary[current_search_id] -= 1
			if shopping_dictionary[current_search_id] <= 0:
				shopping_dictionary.erase(current_search_id)
				Enter()
				searching_for_item = true
			print("Found item with ID: ", current_search_id)
		
func Physics_process(_delta):
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - customer.global_position).normalized()
		customer.velocity = dir * speed * _delta
		customer.move_and_slide()
	
func make_path():
	navigation_agent.target_position = target_position

func _on_wait_timer_timeout():
	Enter()

func _on_interaction_timer_timeout():
	in_interact_cooldown = false
