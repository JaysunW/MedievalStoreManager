extends Node2D

@export var time_service : Node2D
@export var sprite_component : Sprite2D

func _ready() -> void:
	SignalService.ending_work_day.connect(reset_sign)

func interact():
	sprite_component.change_sprite(1)
	time_service.start_work_day()

func reset_sign():
	sprite_component.change_sprite(0)
