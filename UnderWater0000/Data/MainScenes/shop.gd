extends Node2D

var selected_item = null

func buy_item(item, container):
	var player_gold = GoldService.get_gold()
	if item["price"] <= player_gold:
		#  Give player the upgrade
		GoldService.add_gold(-item["price"])
		container.item_bought()
		var tool_stats = DataService.get_tool_data()
		tool_stats[item["name"]][item["id"]]["unlocked"] = true
		DataService.set_tool_data(tool_stats)
	else:
		#  Player didn't have enough money
		container.not_bought()

func _on_texture_button_button_down():
	SceneSwitcherService.switch_scene(SceneSwitcherService.main_scene_path)

func _on_change_scene_mouse_entered():
	$ParallaxBackground/BackParallax/Sign.texture = load("res://Assets/Shop/sign_hover.png")

func _on_change_scene_mouse_exited():
	$ParallaxBackground/BackParallax/Sign.texture = load("res://Assets/Shop/sign.png")
