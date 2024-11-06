extends Node
class_name State

signal transitioned

func Enter():
	pass
	
func Exit():
	pass
		
func Update(_delta):
	pass
	
func Physics_process(_delta):
	pass

func get_random_vector(distance):
	return Vector2(Global.rng.randi_range(-distance,distance),Global.rng.randi_range(-distance,distance)) 
