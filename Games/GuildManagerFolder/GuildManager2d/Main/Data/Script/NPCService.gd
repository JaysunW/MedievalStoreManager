extends Node2D

@export var customer : PackedScene
@export var world_map : TileMap

@export var spawn_point_1 : Marker2D
@export var spawn_point_2 : Marker2D
@export var spawn_point_3 : Marker2D

var new_customer = null

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		var rng = RandomNumberGenerator.new()
		new_customer = customer.instantiate()
		if rng.randi_range(0, 1) == 0:
			new_customer.global_position = spawn_point_1.global_position
		else:
			new_customer.global_position = spawn_point_2.global_position
		world_map.add_child(new_customer)
	if Input.is_action_just_pressed("e"):
		new_customer.set_target(spawn_point_3)
	if Input.is_action_just_pressed("q"):
		new_customer.set_target(spawn_point_1)
