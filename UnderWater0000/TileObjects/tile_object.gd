extends Node2D

@onready var sprite = $Sprite

var health = 100

var animation_frames = 0
var type = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		destroyed()
		
func get_type():
	return type
	
func set_type(new_type):
	type = new_type

func destroyed():
	print("Destroyed")
	queue_free()
	pass
	# destroy object and drop whatever

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
