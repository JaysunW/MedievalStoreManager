extends Node2D

@export var checkout_list : Array
@export var start_checkout : Node2D
var object_dict = {}

func _ready():
	checkout_list.append(start_checkout)
