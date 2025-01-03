extends Node

#Player
signal restrict_player_interaction(bool)
signal restrict_player_movement(bool)

#BuildService
signal chose_building_option
signal chose_expanding_option
signal chose_move_structure
signal chose_remove_structure

#TimeService
signal try_starting_work_day
signal starting_work_day
signal ending_work_day
signal try_ending_day
signal end_day
signal send_customer_schedule(Array)
signal try_spawning_customer(int)
signal check_for_customer_left
signal all_customer_left

#License
signal new_license_bought

#Camera
signal camera_offset(Vector2)

#Worldmap
signal add_to_world
signal remove_structure
signal add_checkout
signal remove_checkout

func restrict_player(interaction:bool = true, movement:bool=true):
	restrict_player_interaction.emit(interaction)
	restrict_player_movement.emit(movement)
	
