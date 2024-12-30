extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var check_timer: Timer = $CheckTimer

@export var customer : PackedScene
@export var world_map : Node2D
@export_group("Positions")
@export var idle_point_list : Array[Marker2D]
@export var leaving_point_list : Array[Marker2D]
@export var entrance_point : Marker2D

@export_category("Stats")
@export var spawn_timer_time = 0.1
var spawn_timer_offset_min_max = 0.1

@export var maximum_npc = 30

var npc_list = []
var customer_dictionary = {}
var leaving_npc_list = []
var customer_id_counter = 0

var daily_customer_schedule = []
var next_hour_schedule = []
var last_hour = -1

func _ready():
	if len(npc_list) < maximum_npc:
		spawn_timer.start()
	SignalService.check_for_customer_left.connect(start_checking_for_customer_left)
	SignalService.try_spawning_customer.connect(try_spawning_customer)
	SignalService.send_customer_schedule.connect(structure_customer_schedule)
		
func _process(_delta):
	if Input.is_action_just_pressed("v"):
		npc_list.pick_random().change_state()

func get_current_checkouts():
	return world_map.checkout_list

func structure_customer_schedule(new_schedule):
	print("New Schedule: ", new_schedule)
	daily_customer_schedule = new_schedule
	next_hour_schedule.resize(60)
	next_hour_schedule.fill(0)

func customer_to_npc(old_customer):
	if old_customer.id == 0:
		return
	if old_customer.id in customer_dictionary:
		customer_dictionary.erase(old_customer.id)
		leaving_npc_list.append(old_customer)
		old_customer

func npc_left(leaving_npc):
	print("npc. ", len(npc_list))
	print("custom. ", len(customer_dictionary))
	print("leaving. ", len(leaving_npc_list))
	var npc_index = leaving_npc_list.find(leaving_npc)
	if npc_index != -1:
		leaving_npc_list.remove_at(npc_index)
		leaving_npc.queue_free()

func get_leaving_point():
	return leaving_point_list.pick_random()

func try_spawning_customer(minute, hour):
	if last_hour != hour:
		last_hour = hour
		if hour < len(daily_customer_schedule):
			next_hour_schedule.fill(0)
			var average_customer = daily_customer_schedule[hour]
			for i in range(average_customer):
				var random_index = Global.rng.randi_range(0, len(next_hour_schedule)-1)
				next_hour_schedule[random_index] += 1
	var next_customer_amount = next_hour_schedule[minute]
	for i in range(next_customer_amount):
		if len(npc_list) - 5 < next_customer_amount:
			spawn_npc()
		var random_index = Global.rng.randi_range(0, len(npc_list)-1)
		var npc = npc_list[random_index]
		npc_list.remove_at(random_index)
		customer_id_counter += 1
		npc.change_state(customer_id_counter)
		customer_dictionary[npc.id] = npc
	
func spawn_npc(new_position = null):
	var new_npc = customer.instantiate()
	if not new_position:
		#randomize position
		if Global.rng.randi_range(0, 1) == 0:
			new_npc.global_position = idle_point_list[0].global_position
		else:
			new_npc.global_position = idle_point_list[1].global_position
	else:
		new_npc.global_position = new_position
	new_npc.prepare_customer(self)
	world_map.add_child(new_npc)
	npc_list.append(new_npc)

func start_checking_for_customer_left():
	print_debug("check for empty store")
	check_timer.start()
	customer_id_counter = 0

func _on_spawn_timer_timeout():
	if len(npc_list) < maximum_npc:
		spawn_npc()
		spawn_timer.start()
	
func _on_check_timer_timeout() -> void:
	if customer_dictionary.is_empty():
		SignalService.all_customer_left.emit()
	else:
		check_timer.start()
