extends StaticBody2D

@onready var skin: Sprite2D = $Skin
@export var content_icon: Sprite2D

@export var package_data = {}

func set_content(input_data):
	package_data = input_data
	content_icon.texture = Loader.shop_item_texture(input_data["sprite_path"], true)

func change_z_index(value):
	skin.z_index = value
	content_icon.z_index = value

func change_hold_mode(is_being_hold):
	if is_being_hold:
		change_z_index(3)
		$Collision.set_deferred("disabled", true)
	else:
		change_z_index(0)
		$Collision.set_deferred("disabled", false)
