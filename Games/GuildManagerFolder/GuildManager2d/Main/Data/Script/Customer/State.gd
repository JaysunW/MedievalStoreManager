extends Node
class_name State

signal transitioned

func Enter():
	pass
	
func Exit():
	pass
		
func Update(_delta):
	pass
	
func Physics_process(delta):
	pass

func get_random_vector(range):
	return Vector2(Global.rng.randi_range(-range,range),Global.rng.randi_range(-range,range)) 
