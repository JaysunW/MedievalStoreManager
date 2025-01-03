extends Node2D

@export var checkout_list : Array
@export var start_checkout : Node2D

var object_dict = {}
var space_dict = {}

func _ready():
	SignalService.remove_checkout.connect(remove_checkout)
	SignalService.remove_structure.connect(remove_structure)
	SignalService.add_checkout.connect(add_checkout)
	SignalService.add_to_world.connect(add_to_world)
	
func add_to_space_dict(pos : Vector2i):
	if pos in space_dict:
		space_dict[pos] += 1
	else:
		space_dict[pos] = 1
	print("ADD: ", space_dict)

func remove_from_space_dict(pos : Vector2i):
	print("Before:\nREM: ", space_dict)
	if not pos in space_dict:
		print_debug("Tried removing position not in space dict")
		return true
	space_dict[pos] -= 1
	if space_dict[pos] <= 0:
		space_dict.erase(pos)
		return true
	return false
	
func remove_structure(pos):
	print("DEL: ", pos)
	if not object_dict.erase(pos):
		print_debug("Tried removing object not in dict")
	print("DICT: ", object_dict.keys())
	
func remove_checkout(checkout):
	var index = checkout_list.find(checkout)
	checkout_list.remove_at(index)
	
func add_checkout(checkout):
	checkout_list.append(checkout)

func add_to_world(object):
	add_child(object)

func get_object_at(pos):
	if not pos in object_dict:
		return null
	return object_dict[pos]
	
