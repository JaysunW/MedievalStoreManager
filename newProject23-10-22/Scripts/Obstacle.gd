extends RigidBody2D

@export var gravity_speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2.DOWN * gravity_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
