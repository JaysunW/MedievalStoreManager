extends State

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var make_path_timer : Timer
@export var target_position : Vector2

var idle_point_list = null
var idle_counter = 0
var constant_offset : Vector2

const speed = 12000

func _ready():
	idle_point_list = customer.npc_service_reference.idle_point_list

func Enter():
	print("Enter")
	for i in range(len(idle_point_list)):
		if customer.global_position == idle_point_list[i].global_position:
			idle_counter = (i + 1) % len(idle_point_list)
	print("Coun: ", idle_counter)
	target_position = idle_point_list[idle_counter].global_position 
	print("current_pos: ", customer.global_position)
	print("pos: ", target_position)
	make_path()
	make_path_timer.start()
	constant_offset = get_random_vector(16)

func Update(delta):
	pass
		
func Physics_process(delta):
	if idle_point_list:
		if not navigation_agent.is_navigation_finished():
			var next_position = navigation_agent.get_next_path_position()
			var dir = (next_position + constant_offset - customer.global_position).normalized()
			customer.velocity = dir * speed * delta
			customer.move_and_slide()
		else:
			idle_counter = (idle_counter + 1) % len(idle_point_list)
			target_position = idle_point_list[idle_counter].global_position 
			make_path()	
			
func get_random_vector(range):
	return Vector2(Global.rng.randi_range(-range,range),Global.rng.randi_range(-range,range)) 
			
func make_path():
	navigation_agent.target_position = target_position + get_random_vector(16)

func _on_make_path_timer_timeout():
	#make_path()
	pass
