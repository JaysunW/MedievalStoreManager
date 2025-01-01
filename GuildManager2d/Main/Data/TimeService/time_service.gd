extends Node2D

class_name TimeService

@export var total_customer : float = 30
@export var start_time = 8
@export var open_time = 1
@export var current_time = 0

@export_group("Exports")
@export var state_machine : Node2D

func _ready() -> void:
	SignalService.try_starting_work_day.connect(start_work_day)
	SignalService.all_customer_left.connect(close_shop)
	SignalService.try_ending_day.connect(start_new_day)
	
func show_time():
	UI.set_ui_time.emit(get_current_minute(), get_current_hour() + start_time)
	
func show_time_mode(time_mode):
	UI.set_ui_time_mode.emit(time_mode)
	
func start_new_day():
	if state_machine.current_state == state_machine.states["evening"]:
		SignalService.end_day.emit()
		state_machine.on_child_transition(state_machine.states["evening"], "morning")
	
func start_work_day():
	if state_machine.current_state == state_machine.initial_state:
		SignalService.starting_work_day.emit()
		state_machine.on_child_transition(state_machine.initial_state, "day")

func send_customer_schedule(new_schedule):
	SignalService.send_customer_schedule.emit(new_schedule)
	
func close_shop():
	SignalService.ending_work_day.emit()
	state_machine.on_child_transition(state_machine.states["day"], "evening")
	current_time = 0

func try_closing_store():
	state_machine.current_state.wait_till_change()
	SignalService.check_for_customer_left.emit()
	
func increase_time():
	current_time += 1
	show_time()
	SignalService.try_spawning_customer.emit(get_current_minute(), get_current_hour())
	if get_current_hour() >= open_time:
		try_closing_store()

func get_current_minute():
	var minute = current_time % 60
	return minute

func get_current_hour():
	var minute = current_time % 60
	var hour = round((current_time - minute) / 60)
	return hour
	
func _on_npc_service_store_emptied() -> void:
	close_shop()
