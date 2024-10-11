extends Node2D

@onready var player = $".."

const SPEED = 300.0

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		player.velocity = direction * SPEED
	else:
		player.velocity = Vector2.ZERO
	player.move_and_slide()
