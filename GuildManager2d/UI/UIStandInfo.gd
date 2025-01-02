extends CanvasLayer

@export var build_name_label : Label
@export var item_name_label : Label
@export var market_value_label : Label
@export var current_value_label : Label

@export var fill_amount_label : Label

var current_item_id = null

func _ready():
	visible = false
	UI.open_stand_info_UI.connect(set_stand_info)
	
func set_stand_info(stand):
	SignalService.restrict_player()
	var stand_data : Dictionary = stand.data
	var item_id : int = stand.get_content_data()["id"]
	current_item_id = item_id
	build_name_label.text = stand_data["name"]
	var item_data = Data.item_data[item_id]
	item_name_label.text = item_data["name"]
	market_value_label.text = str(item_data["market_value"])
	current_value_label.text = str(item_data["value"])
	var amount = stand.get_content_data()["amount"]
	var max_amount = item_data["max_amount"]
	fill_amount_label.text = str(amount) + "/" + str(max_amount)
	visible = true

func update_stand_info():
	var item_data = Data.item_data[current_item_id]
	current_value_label.text = str(item_data["value"])

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
	Data.item_data[current_item_id]["value"] = Data.item_data[current_item_id]["market_value"] 
	if Data.item_data[current_item_id]["value"] <= 0:
		print_debug("Market value equal or less than 0")
	update_stand_info()

func _on_one_more_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] += 1
	if item_data["value"] > Data.item_data[current_item_id]["market_value"] * 5:
		item_data["value"] = Data.item_data[current_item_id]["market_value"] * 5
		Data.item_data[current_item_id] = item_data
	update_stand_info()
	update_stand_info()

func _on_ten_more_button_down():
	var item_data = Data.item_data[current_item_id]
	item_data["value"] += int(item_data["value"] * 0.1)
	if item_data["value"] > Data.item_data[current_item_id]["market_value"] * 5:
		item_data["value"] = Data.item_data[current_item_id]["market_value"] * 5
		Data.item_data[current_item_id] = item_data
	update_stand_info()

func close_info():
	visible = false
	SignalService.restrict_player(false, false)

func _on_close_button_down():
	close_info()
	UI.is_free(true)
