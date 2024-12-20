extends Node2D

@export var time_service : Node2D
@export var sprite_component : Sprite2D

func _ready() -> void:
	SignalService.ending_work_day.connect(sign_show_open)

func interact():
	SignalService.try_starting_work_day.emit(self)

func sign_show_open(is_open = false):
	if is_open:
		sprite_component.change_sprite(1)
	else:
		sprite_component.change_sprite(0)
