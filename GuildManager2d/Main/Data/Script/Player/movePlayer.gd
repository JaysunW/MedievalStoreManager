extends Node2D

@export var player : CharacterBody2D
@export var animation_component : Node2D

const SPEED = 25000.0
var last_move_direction = Vector2.DOWN

var can_move = true

func _physics_process(_delta):
	if can_move:
		var direction = Input.get_vector("left", "right", "up", "down").normalized()
		if direction:
			last_move_direction = direction
			player.velocity = direction * SPEED * _delta
			if abs(direction.y) > abs(direction.x):
				if direction.y > 0:
					animation_component.set_animation("walking")
					animation_component.set_color(Color.AQUA)
				else:
					animation_component.set_animation("walking_back")
					animation_component.set_color(Color.AQUA)
			else:
				animation_component.set_animation("walking_horizontal")
				animation_component.set_flip_h(direction.x < 0)
				animation_component.set_color(Color.AQUA)
		else:
			player.velocity = Vector2.ZERO
			animation_component.set_animation("default")
			animation_component.set_color(Color.AQUA)
		player.move_and_slide()

func _on_ui_stand_info_opened_stand_info():
	can_move = false

func _on_ui_stand_info_closed_stand_info():
	can_move = true
