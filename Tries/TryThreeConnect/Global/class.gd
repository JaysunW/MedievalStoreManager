extends Node

class container_modifier:
	var freeze_content = false
	var decrease_count_through_neighbour = false
	var count = 0
	var sprite = null

	func _init():
		pass
	
	func set_count(input):
		count = input
	
	func init_freeze_content():
		freeze_content = true
	
	func init_decrease_trough_neighbour():
		decrease_count_through_neighbour = true

	func get_sprite():
		return sprite
		
	func set_base_contamination(input):
		count = input
	
	
	func set_sprite(input):
		sprite = input
		
