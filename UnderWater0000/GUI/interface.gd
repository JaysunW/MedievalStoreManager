extends Control

@onready var o2_bar = $O2_bar
@onready var coin_counter = $Coin_counter

func change_coins(value):
	coin_counter.update(value)
	
func update_o2_bar(percentage):
	o2_bar.update(percentage)
