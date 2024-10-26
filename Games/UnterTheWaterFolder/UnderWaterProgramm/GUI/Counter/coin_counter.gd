extends Control

@onready var counter_label = $TextureRect/Label
var gold_update_signal = null 

func _ready():
	update_counter()
	gold_update_signal = GoldService.get_gold_signal()
	gold_update_signal.connect(update_counter)

func update_counter():
	GoldService.initialize()
	var string = GoldService.get_gold_str()
	var string_list = string.split(".")
	if string_list.size() > 1:
		var first = string_list[0]
		var second = string_list[1]
		second = second.erase(max(second.length() - 2 - (first.length() - 1),0), first.length() - 1)
		if second.length() > 1:
			string = first + "." + second
		else:
			string = first + second
	
	counter_label.text = string
