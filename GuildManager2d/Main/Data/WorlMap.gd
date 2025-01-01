extends Node2D

@export var checkout_list : Array
@export var start_checkout : Node2D
var object_dict = {}

func _ready():
	SignalService.add_to_world.connect(add_to_world)
	checkout_list.append(start_checkout)
	
func add_to_world(object):
	add_child(object)
