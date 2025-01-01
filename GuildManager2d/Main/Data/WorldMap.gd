extends Node2D

@export var checkout_list : Array
@export var start_checkout : Node2D
var object_dict = {}

func _ready():
	SignalService.remove_checkout.connect(remove_checkout)
	SignalService.add_checkout.connect(add_checkout)
	SignalService.add_to_world.connect(add_to_world)
	checkout_list.append(start_checkout)
	
func remove_checkout(checkout):
	pass
	#remove_checkout out of list
	
func add_checkout(checkout):
	checkout_list.append(checkout)	

func add_to_world(object):
	add_child(object)
