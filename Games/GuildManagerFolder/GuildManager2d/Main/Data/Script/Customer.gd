extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent
const speed = 15000

@export var target : Node2D

func _physics_process(_delta):
	if target and not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var dir = (next_position - global_position).normalized()
		velocity = dir * speed * _delta
		move_and_slide()
	
func set_target(target_object):
	target = target_object
	make_paht()
	
func make_paht():
	navigation_agent.target_position = target.global_position
	print("t: ", target.global_position)
