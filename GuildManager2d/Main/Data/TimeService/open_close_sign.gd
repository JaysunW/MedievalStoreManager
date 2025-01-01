extends Node2D

@export var sprite_component : Sprite2D

func _ready() -> void:
	SignalService.ending_work_day.connect(show_closed)
	SignalService.starting_work_day.connect(show_open)

func interact():
	SignalService.try_starting_work_day.emit()

func show_open():
	sprite_component.change_sprite(1)
	
func show_closed():
	sprite_component.change_sprite(0)
