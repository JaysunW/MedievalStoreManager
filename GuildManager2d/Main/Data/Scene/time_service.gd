extends Node2D

@export var ui_time : CanvasLayer 
@export var state_machine : Node2D
@export var customer_service : Node2D

var close_time = 20

func change_time(current_time):
	ui_time.set_time(current_time)

func start_day():
	ui_time.set_time_mode("Day")
	state_machine.on_child_transition(state_machine.initial_state, "day")

func check_for_empty_store():
	customer_service.check_for_empty_store()
	
func close_shop():
	ui_time.set_time_mode("Evening")
	state_machine.on_child_transition(state_machine.states["day"], "evening")

func _on_npc_service_store_emptied() -> void:
	close_shop()
