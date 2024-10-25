extends Control

@onready var o2_bar = $O2_bar
@onready var coin_counter = $Coin_counter

func _ready():
	$".".visible = true

func change_coins(value):
	coin_counter.update(value)
	
func update_o2_bar(percentage):
	o2_bar.update(percentage)

func set_o2_front(input):
	o2_bar.set_front_sprite(input)
	
func set_o2_back(input):
	o2_bar.set_back_sprite(input)
