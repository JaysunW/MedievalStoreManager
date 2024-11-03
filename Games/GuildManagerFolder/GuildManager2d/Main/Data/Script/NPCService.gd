extends Node2D

@onready var spawn_timer = $SpawnTimer

@export var customer : PackedScene
@export var world_map : TileMap

@export var spawn_point_1 : Marker2D
@export var spawn_point_2 : Marker2D
@export var entrance_point : Marker2D

@export var spawn_timer_time = 5
var spawn_timer_offset_min_max = 10

var customer_list = []
var is_spawning_customer = false

func change_customer_cycle(should_start):
	is_spawning_customer = should_start
	if should_start:
		spawn_timer.wait_time = spawn_timer_time + Global.rng.randi_range(0, spawn_timer_offset_min_max)
		spawn_timer.start()
	else:
		spawn_timer.stop()
	
func spawn_customer(new_position = null):
	var new_customer = customer.instantiate()
	if not new_position:
		if Global.rng.randi_range(0, 1) == 0:
			new_customer.global_position = spawn_point_1.global_position
		else:
			new_customer.global_position = spawn_point_2.global_position
	else:
		new_customer.global_position = new_position
	world_map.add_child(new_customer)
	new_customer.prepare_customer(entrance_point)

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		change_customer_cycle(not is_spawning_customer)

func _on_spawn_timer_timeout():
	spawn_customer()
