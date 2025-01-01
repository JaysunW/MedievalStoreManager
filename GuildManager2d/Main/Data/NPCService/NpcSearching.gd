extends State

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

@onready var think_timer = $ThinkTimer
@onready var interact_timer = $InteractTimer

var shopping_dictionary : Dictionary

var current_search_id : int
var current_search_stand = null
var found_item_list : Array

var searching_for_item = true
var in_interact_cooldown = false
var speed : int

func _ready():
	speed = customer.speed
	think_timer.wait_time = Global.rng.randf_range(2, 4)

func Enter():
	restart_search()
		
func restart_search():	
	var stock_stand_list = Stock.get_filled_stands()
	shopping_dictionary = customer.shopping_dictionary
	#print_debug("Stand_list: ",stock_stand_list, " Shopping: ", shopping_dictionary)
	var id_list = shopping_dictionary.keys()
	
	if id_list.is_empty():
		if found_item_list:
			#print_debug("Found item go to checkout Found_item_list: ", found_item_list)
			customer.basket_list = found_item_list
			Change_state("buying")
		else:
			Change_state("leaving")
		return 
		
	current_search_id = id_list.pick_random()
	#print_debug("Current_id: ", current_search_id, " id_list:" , id_list)
	if current_search_id in stock_stand_list:
		var stand_list_with_search_item = stock_stand_list[current_search_id]
		current_search_stand = stand_list_with_search_item.pick_random()
		target_position = current_search_stand.get_npc_interaction_position()
		make_path()
		if not navigation_agent.is_target_reachable():
			#print_debug("Couldn't find target")
			target_position = self.global_position
			make_path()
			shopping_dictionary.erase(current_search_id)
			think_timer.start()
			think_timer.wait_time = Global.rng.randf_range(2, 4)
		else:
			#print_debug("Target reachable")
			searching_for_item = false
	else:
		shopping_dictionary.erase(current_search_id)
		think_timer.start()
		think_timer.wait_time = Global.rng.randf_range(2, 4)
		#print_debug("Couldn't find item with id: ", current_search_id)
		
func Exit():
	searching_for_item = true
	in_interact_cooldown = false
	current_search_stand = null

func Update(_delta):
	if not navigation_agent.is_navigation_finished():
		return
		
	if searching_for_item or in_interact_cooldown:
		return 
		
	if not current_search_stand or current_search_stand.is_empty():
		#print_debug("current_stand empty or not there")
		searching_for_item = true
		restart_search()
		return
	
	if current_search_stand.get_content_data()["id"] == current_search_id:
		
		in_interact_cooldown = true
		interact_timer.start()
		
		# Decide whether to buy it or not!
		
		var stand_content = current_search_stand.get_content_data().duplicate()
		stand_content["amount"] = 1
		add_item_to_found_list(stand_content)
		current_search_stand.take_from_shelf()
		shopping_dictionary[current_search_id] -= 1
		#print_debug("Found item with ID: ", current_search_id, " dic: ", shopping_dictionary)
		if shopping_dictionary[current_search_id] <= 0:
			shopping_dictionary.erase(current_search_id)
			searching_for_item = true
			restart_search()
		
func Physics_process(_delta):
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - customer.global_position).normalized()
		customer.change_animation(dir)
		customer.velocity = dir * speed * _delta
		customer.move_and_slide()
	else:
		customer.change_animation(Vector2.ZERO)

func add_item_to_found_list(item):
	var id = -1
	for i in range(len(found_item_list)):
		if found_item_list[i]["id"] == item["id"]:
			id = i
			break
	if id == -1:
		found_item_list.append(item)
	else:
		found_item_list[id]["amount"] += 1
	
func make_path():
	navigation_agent.target_position = target_position

func _on_wait_timer_timeout():
	restart_search()

func _on_interaction_timer_timeout():
	in_interact_cooldown = false
