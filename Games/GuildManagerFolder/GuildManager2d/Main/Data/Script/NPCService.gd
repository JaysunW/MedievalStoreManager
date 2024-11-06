extends Node2D

@onready var spawn_timer = $SpawnTimer

@export var customer : PackedScene
@export var world_map : TileMap

@export var idle_point_list : Array[Marker2D]
@export var entrance_point : Marker2D

@export var spawn_timer_time = 0.1
var spawn_timer_offset_min_max = 0.1

var customer_list = []
var is_spawning_customer = false

func change_customer_cycle(should_start):
	is_spawning_customer = should_start
	if should_start:
		spawn_customer()
		spawn_timer.wait_time = spawn_timer_time + Global.rng.randi_range(0, spawn_timer_offset_min_max)
		spawn_timer.start()
	else:
		spawn_timer.stop()
	
func spawn_customer(new_position = null):
	var new_customer = customer.instantiate()
	if not new_position:
		if Global.rng.randi_range(0, 1) == 0:
			new_customer.global_position = idle_point_list[0].global_position
		else:
			new_customer.global_position = idle_point_list[1].global_position
	else:
		new_customer.global_position = new_position
	new_customer.prepare_customer(self)
	world_map.add_child(new_customer)
	customer_list.append(new_customer)

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		change_customer_cycle(not is_spawning_customer)
	if Input.is_action_just_pressed("v"):
		customer_list.pick_random().change_state()

func _on_spawn_timer_timeout():
	spawn_customer()
