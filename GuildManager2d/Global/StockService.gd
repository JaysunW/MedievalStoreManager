extends Node

var stock_list = {}
var stock_stand_list = {}

func get_filled_stands():
	return stock_stand_list

func print_current_stock():
	print("Current stock list: ", stock_list)
	print("Current stand stock list: ", stock_stand_list)

func add_to_stock(id, stand):
	if id in stock_list.keys():
		stock_list[id] += 1
		if not stand in stock_stand_list[id]:
			stock_stand_list[id].append(stand)
	else:
		stock_list[id] = 1
		stock_stand_list[id] = [stand]

func take_from_stock(id, stand, is_empty=false):
	if is_empty:
		stock_stand_list[id].erase(stand)
	if id in stock_list.keys():
		stock_list[id] -= 1
		if stock_list[id] == 0:
			stock_list.erase(id)
			stock_stand_list.erase(id)
	else:
		print_debug("Tried taking from stock which wasn't in stock")
