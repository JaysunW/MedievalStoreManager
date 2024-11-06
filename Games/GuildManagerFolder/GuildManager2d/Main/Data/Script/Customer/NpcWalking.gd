extends State

class_name NpcWalking

const speed = 12000

@export var customer : CharacterBody2D
@export var navigation_agent : NavigationAgent2D
@export var target_position : Vector2

var entrance_point = null
var constant_offset : Vector2

func _ready():
	entrance_point = customer.npc_service_reference.entrance_point

func Enter():
	target_position = entrance_point.global_position
	constant_offset = get_random_vector(16)
	make_path()

func Update(delta):
	pass
		
func Physics_process(delta):
	if not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position + constant_offset - customer.global_position).normalized()
		customer.velocity = dir * speed * delta
		customer.move_and_slide()
	else:
		transitioned.emit(self, "idle")
			
func make_path():
	navigation_agent.target_position = target_position + get_random_vector(16)
