class_name Drop
extends RigidBody2D

var type = null

func _ready():
	$Lifetime.start()

func update_sprite():
	pass

func destroy_drop():
	DropService.call("erase_drop", self)
	queue_free()

func _on_lifetime_timeout():
	destroy_drop()

func set_drop_type(input):
	type = input
