extends Node2D
class_name world_map

@export var checkout_list : Array
@export var start_checkout : Node2D

var object_dict = {}

func _ready():
	SignalService.remove_checkout.connect(remove_checkout)
	SignalService.remove_structure.connect(remove_structure)
	SignalService.add_checkout.connect(add_checkout)
	SignalService.add_to_world.connect(add_to_world)
	
func remove_structure(pos):
	if not object_dict.erase(pos):
		print("not in dictionary")
	
func remove_checkout(checkout):
	var index = checkout_list.find(checkout)
	checkout_list.remove_at(index)
	
func add_checkout(checkout):
	checkout_list.append(checkout)
	print(checkout_list)

func add_to_world(object):
	add_child(object)
