extends Node2D

class_name TimeService

@export var ui_time : CanvasLayer 
@export var state_machine : Node2D
@export var customer_service : Node2D

var total_customer : float = 30

var start_time = 8
var close_time = 1
var current_time = 0

func _ready() -> void:
	customer_service.store_emptied.connect(close_shop)

func show_time():
	ui_time.set_time(get_current_minute(), get_current_hour() + start_time)
	
func start_day():
	ui_time.set_time_mode("Day")
	state_machine.on_child_transition(state_machine.initial_state, "day")

func send_customer_schedule(new_schedule):
	customer_service.structure_customer_schedule(new_schedule)

func check_for_empty_store():
	customer_service.check_for_empty_store()
	
func close_shop():
	ui_time.set_time_mode("Evening")
	customer_service.close_store()
	state_machine.on_child_transition(state_machine.states["day"], "evening")

func check_before_closing():
	state_machine.current_state.wait_till_change()
	customer_service.check_for_empty_store()
	
func increase_time():
	current_time += 1
	ui_time.set_time(get_current_minute(), get_current_hour() + start_time)
	customer_service.try_spawning_customer(get_current_minute(), get_current_hour())
	if get_current_hour() >= close_time:
		print("End day")
		check_before_closing()

func get_current_minute():
	var minute = current_time % 60
	return minute

func get_current_hour():
	var minute = current_time % 60
	var hour = round((current_time - minute) / 60)
	return hour
	
func _on_npc_service_store_emptied() -> void:
	close_shop()
