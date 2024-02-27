extends Node2D

var selected_item = null

func buy_item(item, container):
	var player_gold = GoldService.get_gold()
	if item["price"] <= player_gold:
		#Give player the upgrade
		GoldService.add_gold(-item["price"])
		container.item_bought()
		print("Something bought")
	else:
		pass
		# Show that it couldn't be bought
