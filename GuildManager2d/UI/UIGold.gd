extends CanvasLayer

@export var gold_label : Label
@export var silver_label : Label
@export var copper_label : Label

@export var color_flash_timer : Timer

func _ready():
	Gold.changed_gold_amount.connect(set_gold_display)
	Gold.flash.connect(flash_display)
	set_gold_display()

func set_gold_display():
	var value = int(Data.player_data["gold"])
	var copper_value = value % 1000
	copper_label.text = str(copper_value)
	var silver_value = (value - copper_value) % 1000000
	silver_label.text = str(silver_value/1000)
	var gold_value = (value - copper_value - silver_value) % 1000000000
	gold_label.text = str(gold_value/1000000) 

func flash_display(color, flash_time = 0.1):
	gold_label.modulate = color
	silver_label.modulate = color
	copper_label.modulate = color
	color_flash_timer.start(flash_time)

func _on_color_flash_timer_timeout():
	gold_label.modulate = Color.WHITE
	silver_label.modulate = Color.WHITE
	copper_label.modulate = Color.WHITE
