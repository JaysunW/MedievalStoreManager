extends Node

var player_gold = 0
signal gold_changed

func get_gold_signal():
	return gold_changed

func add_gold(value):
	player_gold += value
	if player_gold < 0:
		print("Somethings wrong with the amount of Gold: " + str(player_gold))
	gold_changed.emit()
		
func set_gold(input):
	player_gold = input

func get_gold():
	return player_gold
	
func get_gold_str():
	return convert_value_to_str(player_gold)
	
func convert_value_to_str(value):
	var list = ["K", "M", "B", "T"]
	for i in range(list.size()):
		var tmp = pow(10,(i + 1) * 3)
		if value > tmp - 1 and value < pow(10,(i + 2) * 3):
			var output_string = ("%3.2f" % (value/tmp)) + list[i]
			print(output_string)
			return output_string
	return str(value)
