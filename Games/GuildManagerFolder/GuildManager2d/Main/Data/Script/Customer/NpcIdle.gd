extends State

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

var idle_point_list = null
var idle_counter = 0
var constant_offset : Vector2
var speed : int

func _ready():
	speed = customer.speed
	idle_point_list = customer.npc_service_reference.idle_point_list

func Enter():
	for i in range(len(idle_point_list)):
		if customer.global_position == idle_point_list[i].global_position:
			idle_counter = (i + 1) % len(idle_point_list)
	target_position = idle_point_list[idle_counter].global_position 
	constant_offset = get_random_vector(16)
	make_path()

func Update(_delta):
	pass
		
func Physics_process(_delta):
	if idle_point_list:
		if not navigation_agent.is_navigation_finished():
			var next_position = navigation_agent.get_next_path_position()
			var dir = (next_position + constant_offset - customer.global_position).normalized()
			customer.velocity = dir * speed * _delta
			customer.move_and_slide()
		else:
			idle_counter = (idle_counter + 1) % len(idle_point_list)
			target_position = idle_point_list[idle_counter].global_position 
			constant_offset = get_random_vector(16)
			make_path()
			
func make_path():
	navigation_agent.target_position = target_position + get_random_vector(16)
