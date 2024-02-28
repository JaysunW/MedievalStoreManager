class_name Drop
extends RigidBody2D

var type = 0
var border_idx = 0

func _ready():
	$Lifetime.start()

func update_sprite():
	pass

func set_texture(texture):
	$Sprite.texture = texture

func set_type(input):
	type = input

func set_border_idx(value):
	border_idx = value

func get_border_idx():
	return border_idx

func collect_drop():
	DropService.collect_drop(type, border_idx)
	DropService.erase_drop(self)
	queue_free()

func _on_lifetime_timeout():
	destroy_drop()

func destroy_drop():
	DropService.erase_drop(self)
	queue_free()
