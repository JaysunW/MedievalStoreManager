extends State

@onready var line_2d: Line2D = $"../../Line2D"

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

@onready var wait_timer = $WaitTimer

var checkout_list : Array
var current_checkout : StaticBody2D
var patience_counter = 0
var queue_distance = 24
var speed : int

var is_waiting_open_checkout = false

var next_customer = null
var spot_nr = INF

func _ready():
	speed = customer.speed
	checkout_list = customer.npc_service_reference.get_current_checkouts()

func find_open_checkout():
	var output_checkout = null
	var min_checkout_queue = INF
	for checkout in checkout_list:
		if not checkout.is_full() and checkout.get_queue_size() < min_checkout_queue:
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
	next_customer = null
	spot_nr = INF
	
func search_checkout():
	current_checkout = find_open_checkout()
	if current_checkout:
		target_position = current_checkout.get_marker().global_position
		make_path()
		is_waiting_open_checkout = false
		if navigation_agent.is_target_reachable():
			current_checkout.new_customer.connect(set_next_customer)
			current_checkout.next_customer.connect(next_spot)
			current_checkout.no_customer_in_queue.connect(remove_next_customer)
			current_checkout.reserve_spot()
			return
		#print_debug("Couldn't get to checkout, wait until reachable or steal")
		target_position = self.global_position
		make_path()
	is_waiting_open_checkout = true
	wait_timer.start()

func set_next_customer(input):
	next_customer = input

func remove_next_customer():
	next_customer = null

func next_spot():
	spot_nr -= 1

func Update(_delta):
	if customer.has_been_billed:
		#print_debug("Paid for items and is leaving")
		Change_state("leaving")
		
func Physics_process(_delta):	
	if is_waiting_open_checkout :
		return
	
	if not navigation_agent.is_target_reachable():
		target_position = self.global_position
		make_path()
		is_waiting_open_checkout = true
		wait_timer.start()
		spot_nr = INF
		#TODO teleport to start Portal
		return

	if next_customer and spot_nr > 0:
		if target_position != next_customer.position:
			target_position = next_customer.position		
			make_path()		
		var distance_vec = customer.position.distance_to(next_customer.position)
		if distance_vec < queue_distance:
			customer.change_animation(Vector2.ZERO)
			if not customer.is_waiting_in_queue:
				disconnect_checkout_signals()
				spot_nr = current_checkout.add_customer(customer)
				customer.is_waiting_in_queue = true
			return
		if not navigation_agent.is_navigation_finished():
			var next_position = navigation_agent.get_next_path_position()
			var dir = (next_position - customer.global_position).normalized()
			customer.change_animation(dir)
			customer.velocity = dir * speed * _delta
			customer.move_and_slide()
		else:
			customer.change_animation(Vector2.ZERO)
		return 
	if target_position != current_checkout.position:
		target_position = current_checkout.position		
		make_path()
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
		disconnect_checkout_signals()
		spot_nr = current_checkout.add_customer(customer)
		customer.is_waiting_in_queue = true
		
func disconnect_checkout_signals():
	if not current_checkout:
		return
	if current_checkout.new_customer.is_connected(set_next_customer):
		current_checkout.new_customer.disconnect(set_next_customer)
	if current_checkout.next_customer.is_connected(set_next_customer):
		current_checkout.next_customer.disconnect(set_next_customer)
	if current_checkout.no_customer_in_queue.is_connected(set_next_customer):
		current_checkout.no_customer_in_queue.disconnect(set_next_customer)
	
func make_path():
	navigation_agent.target_position = target_position

func _on_wait_timer_timeout():
	if patience_counter < customer.patience:
		#print_debug("Waiting: ", patience_counter + 1, "/", customer.patience)
		patience_counter += 1
		search_checkout()
	else: 
		#print_debug("Customer was impatient and left without paying")
		Change_state("leaving")
