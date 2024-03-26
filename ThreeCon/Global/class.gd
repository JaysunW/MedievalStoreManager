extends Node

class container_modifier:
	var freeze_content = false
	var decrease_count_through_neighbour = false
	var count = 0
	var sprite = null

	func _init():
		pass
	
	func init_freeze_content():
		freeze_content = true
	
	func init_decrease_trough_neighbour():
		decrease_count_through_neighbour = true
