extends Node2D

@onready var player = $".."

const SPEED = 300.0
var last_move_direction = Vector2.ZERO

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		last_move_direction = direction
		player.velocity = direction * SPEED
	else:
		player.velocity = Vector2.ZERO
	player.move_and_slide()
