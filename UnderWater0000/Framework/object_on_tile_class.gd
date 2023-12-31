class_name ObjectOnTile
extends Node2D

@onready var sprite = $Sprite

var rng = RandomNumberGenerator.new()
var grid_service = null
var max_health = 100
var health = max_health

var animation_frames = 0

var type = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		destroyed()
		
func get_type():
	return type
	
func set_grid_service(input):
	grid_service = input
func set_type(new_type):
	type = new_type

func destroyed():
	grid_service.call("destroyed_coral", position, type)
	queue_free()
