extends State


@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

@onready var wait_timer = $WaitTimer

var checkout_list : Array
var current_checkout : StaticBody2D
var speed : int
var patience_counter = 0

var is_waiting_open_checkout = false
var is_waiting_for_billing = false

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
	print("go to checkout")
	current_checkout = find_open_checkout()
	if current_checkout:
		print("Found a checkout")
		target_position = current_checkout.get_marker().global_position
		make_path()
		is_waiting_open_checkout = false
		if navigation_agent.is_target_reachable():
			current_checkout.reserve_spot()
			return
		
		print_debug("Couldn't get to checkout, wait until reachable or steal")
		target_position = self.global_position
		make_path()
	is_waiting_open_checkout = true
	wait_timer.start()
		
func Exit():
	patience_counter = 0 
	is_waiting_for_billing = false
	is_waiting_open_checkout = false
	customer.has_been_billed = false

func Update(_delta):
	if customer.has_been_billed:
		print("Paid for items and is leaving")
		Change_state("idle")
		
func Physics_process(_delta):	
	if is_waiting_for_billing or is_waiting_open_checkout:
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
		
	current_checkout.add_shopper(customer)
	is_waiting_for_billing = true
		
			
func make_path():
	navigation_agent.target_position = target_position + get_random_vector(16)

func _on_wait_timer_timeout():
	if patience_counter < customer.patience:
		print("Waiting: ", patience_counter)
		patience_counter += 1
		Enter()
	else: 
		print("Customer was impatient and left without paying")
		Change_state("idle")
