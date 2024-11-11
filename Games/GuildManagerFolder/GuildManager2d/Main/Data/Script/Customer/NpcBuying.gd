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
		if checkout.get_queue_size() < min_checkout_queue:
			output_checkout = checkout
			min_checkout_queue = checkout.get_queue_size()
	return output_checkout

func Enter():
	print("go to checkout")
	current_checkout = find_open_checkout()
	if current_checkout:
		print("Found a checkout")
		is_waiting_open_checkout = false
		target_position = current_checkout.get_marker().global_position
		make_path()
	else:
		print("Waiting")
		wait_timer.start()
		
func Exit():
	patience_counter = 0 
	is_waiting_open_checkout = false
	customer.has_been_billed = false

func Update(_delta):
	pass
		
func Physics_process(_delta):
	if customer.has_been_billed:
		print("Paid for items and is leaving")
		Change_state("idle")
		
	if is_waiting_for_billing:
		return
		
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - customer.global_position).normalized()
		customer.change_animation(dir)
		customer.velocity = dir * speed * _delta
		customer.move_and_slide()
	elif not is_waiting_open_checkout:
		print("At checkout and waiting")
		if current_checkout.is_full():
			print("Checkout full")
			is_waiting_open_checkout = true
			Enter()
		else:
			current_checkout.add_shopper(customer)
			is_waiting_for_billing = true
			
func make_path():
	navigation_agent.target_position = target_position + get_random_vector(16)

func _on_wait_timer_timeout():
	if patience_counter < customer.patience:
		print("Waiting: ", patience_counter)
		patience_counter =+ 1
		wait_timer.start()
	else: 
		Change_state("idle")
	pass # Replace with function body.
