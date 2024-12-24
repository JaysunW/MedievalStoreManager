extends State

@onready var line_2d: Line2D = $"../../Line2D"

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2
@export var view_component : Node2D

@onready var wait_timer = $WaitTimer

var checkout_list : Array
var current_checkout : StaticBody2D
var speed : int
var patience_counter = 0

var is_waiting_open_checkout = false

var spot_nr = 0

func _ready():
	speed = customer.speed
	checkout_list = customer.npc_service_reference.get_current_checkouts()

func find_open_checkout():
	var output_checkout = null
	var min_checkout_queue = INF
	for checkout in checkout_list:
		if (not checkout.is_full()) and checkout.get_queue_size() < min_checkout_queue:
			output_checkout = checkout
			min_checkout_queue = checkout.get_queue_size()
	return output_checkout

func Enter():
	search_checkout()

func Exit():
	patience_counter = 0 
	is_waiting_open_checkout = false
	customer.has_been_billed = false
	customer.is_waiting_in_queue = false
	
func search_checkout():
	#print("go to checkout")
	current_checkout = find_open_checkout()
	if current_checkout:
		#print("Found a checkout")
		target_position = current_checkout.get_marker().global_position
		make_path()
		is_waiting_open_checkout = false
		if navigation_agent.is_target_reachable():
			spot_nr = current_checkout.reserve_spot(customer)
			current_checkout.next_shopper.connect(next_spot)
			return
		
		#print_debug("Couldn't get to checkout, wait until reachable or steal")
		target_position = self.global_position
		make_path()
	is_waiting_open_checkout = true
	wait_timer.start()

func next_spot():
	spot_nr -= 1

func Update(_delta):
	if customer.has_been_billed:
		#print("Paid for items and is leaving")
		Change_state("idle")
		
func Physics_process(_delta):	
	if is_waiting_open_checkout:
		return
	
	if not navigation_agent.is_target_reachable():
		target_position = self.global_position
		make_path()
		is_waiting_open_checkout = true
		wait_timer.start()
		spot_nr = 0
		return
	
	if spot_nr > 0:
		if customer.position.distance_to(target_position) < 16 + 24 * spot_nr:
			customer.change_animation(Vector2.ZERO)
			return
			
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - customer.global_position).normalized()
		customer.change_animation(dir)
		customer.velocity = dir * speed * _delta
		customer.move_and_slide()
		return
	else:
		customer.change_animation(Vector2.ZERO)
	
	if not customer.is_waiting_in_queue:
		customer.is_waiting_in_queue = true
		
func move_in_queue(new_position):
	target_position = new_position
	make_path()
	pass

func make_path():
	navigation_agent.target_position = target_position + get_random_vector(4)

func _on_wait_timer_timeout():
	if patience_counter < customer.patience:
		#print("Waiting: ", patience_counter + 1, "/", customer.patience)
		patience_counter += 1
		search_checkout()
	else: 
		#print_debug("Customer was impatient and left without paying")
		Change_state("idle")
