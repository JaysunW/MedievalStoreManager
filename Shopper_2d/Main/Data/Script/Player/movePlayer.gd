extends Node2D

@export var player : CharacterBody2D
@export var skin : Sprite2D

const SPEED = 25000.0
var last_move_direction = Vector2.DOWN

var can_move = true

func _physics_process(_delta):
	if can_move:
		var direction = Input.get_vector("left", "right", "up", "down").normalized()
		if direction:
			last_move_direction = direction
			player.velocity = direction * SPEED * _delta
		else:
			player.velocity = Vector2.ZERO
		player.move_and_slide()

func _on_ui_stand_info_opened_stand_info():
	can_move = false

func _on_ui_stand_info_closed_stand_info():
	can_move = true
