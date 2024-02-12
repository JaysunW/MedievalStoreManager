extends Node

var player_gold = 0

func add_gold(value):
	player_gold += value
	if player_gold < 0:
		print("Somethings wrong with the amount of Gold: " + str(player_gold))
		
func set_gold(input):
	player_gold = input

func get_gold():
	return player_gold

