class_name ObjectOnTile
extends Node2D

var sprite = null
var animation = null
var frame = null

var rng = RandomNumberGenerator.new()
var grid_service = null
var max_health = 100
var health = max_health

var animation_frames = 0

var type = null

func _ready():
	sprite = $Sprite

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
	queue_free()
