extends Control

@onready var counter_label = $TextureRect/Label
var gold_update_signal = null 

func _ready():
	update_counter()
	gold_update_signal = GoldService.get_gold_signal()
	gold_update_signal.connect(update_counter)

func update_counter():
	counter_label.text = GoldService.get_gold_str()
