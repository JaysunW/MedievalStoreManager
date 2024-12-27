extends Node

signal restrict_player_interaction(bool)
signal restrict_player_movement(bool)

signal try_starting_work_day
signal starting_work_day
signal ending_work_day

signal send_customer_schedule(Array)
signal try_spawning_customer(int)
signal check_for_customer_left
signal all_customer_left

signal new_license_bought

signal camera_offset(Vector2)

signal next_customer

func restrict_player(interaction:bool = true, movement:bool=true):
	restrict_player_interaction.emit(interaction)
	restrict_player_movement.emit(movement)
	
