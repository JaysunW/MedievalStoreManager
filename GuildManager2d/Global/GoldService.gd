extends Node

signal changed_gold_amount
signal flash(Color)

func has_enough_gold(value):
	var current_gold = Data.player_data["gold"]
	var new_gold = current_gold - value
	if new_gold < 0:
		return false
	return true

func pay(value):
	var current_gold = Data.player_data["gold"]
	var new_gold = current_gold - value
	if new_gold < 0:
		flash.emit(Color.FIREBRICK)
		return false
	Data.player_data["gold"] = new_gold
	changed_gold_amount.emit()
	return true

func set_gold(value):
	Data.player_data["gold"] = value
	changed_gold_amount.emit()
	
func add_gold(value):
	Data.player_data["gold"] += value
	changed_gold_amount.emit()
