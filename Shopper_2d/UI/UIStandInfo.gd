extends CanvasLayer

@export var buildNameLabel : Label
@export var itemNameLabel : Label
@export var marketValueLabel : Label
@export var currentValueLabel : Label

signal opened_stand_info
signal closed_stand_info

var current_item_id = null

func _ready():
	visible = false

func set_stand_info(stand_data, item_id):
	print(stand_data)
	current_item_id = item_id
	buildNameLabel.text = stand_data["name"]
	var item_data = Data.item_data[item_id]
	itemNameLabel.text = item_data["name"]
	marketValueLabel.text = str(item_data["average_value"])
	currentValueLabel.text = str(item_data["value"])
	opened_stand_info.emit()
	visible = true

func update_stand_info():
	var item_data = Data.item_data[current_item_id]
	currentValueLabel.text = str(item_data["value"])

func _on_ten_less_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] -= int(item_data["value"] * 0.1) 
	if item_data["value"] < 0:
		item_data["value"] = 0
		Data.item_data[current_item_id] = item_data
	update_stand_info()

func _on_one_less_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] -= 1
	if item_data["value"] < 0:
		item_data["value"] = 0
		Data.item_data[current_item_id] = item_data
	update_stand_info()

func _on_market_prize_reset_button_down():
	Data.item_data[current_item_id]["value"] = Data.item_data[current_item_id]["average_value"] 
	if Data.item_data[current_item_id]["value"] <= 0:
		print_debug("Market value equal or less than 0")
	update_stand_info()

func _on_one_more_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] += 1
	if item_data["value"] > Data.item_data[current_item_id]["average_value"] * 5:
		item_data["value"] = Data.item_data[current_item_id]["average_value"] * 5
		Data.item_data[current_item_id] = item_data
	update_stand_info()
	update_stand_info()

func _on_ten_more_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] += int(item_data["value"] * 0.1)
	if item_data["value"] > Data.item_data[current_item_id]["average_value"] * 5:
		item_data["value"] = Data.item_data[current_item_id]["average_value"] * 5
		Data.item_data[current_item_id] = item_data
	update_stand_info()

func close_info():
	visible = false
	closed_stand_info.emit()

func _on_close_button_down():
	close_info()
	UI.is_free(true)
