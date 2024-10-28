extends StaticBody2D

@onready var skin = $Skin

@export var data = {}

func set_content(input_data):
	data = input_data

func change_hold_mode(is_being_hold):
	if is_being_hold:
		skin.z_index = 3
		$Collision.set_deferred("disabled", true)
	else:
		skin.z_index = 0
		$Collision.set_deferred("disabled", false)
