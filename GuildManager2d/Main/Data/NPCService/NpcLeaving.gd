extends State

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

var speed : int

func _ready():
	speed = customer.speed

func Physics_process(_delta):
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - customer.global_position).normalized()
		customer.change_animation(dir)
		customer.velocity = dir * speed * _delta
		customer.move_and_slide()
	else:
		customer.npc_service_reference.npc_left(customer)

func Enter():
	customer.npc_service_reference.customer_to_npc(customer)
	#TODO: if not possible to leave teleport and try then to leave
	var leave_point = customer.npc_service_reference.get_leaving_point()
	target_position = leave_point.position
	make_path()
	
func make_path():
	navigation_agent.target_position = target_position
