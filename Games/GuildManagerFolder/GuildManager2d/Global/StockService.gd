extends Node

var stock_list = {}

func print_current_stock():
	print("Current stock list: ", stock_list)

func add_to_stock(id):
	if id in stock_list.keys():
		stock_list[id] += 1
	else:
		stock_list[id] = 1

func take_from_stock(id):
	if id in stock_list.keys():
		stock_list[id] -= 1
		if stock_list[id] == 0:
			stock_list.erase(id)
	else:
		print_debug("Tried taking from stock which wasn't in stock")
