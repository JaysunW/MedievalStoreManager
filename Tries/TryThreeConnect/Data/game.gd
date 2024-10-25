extends Node2D

@export var width = 10
@export var height = 10

func _ready():
	width = clamp(width, 5, 40)
	height = clamp(height, 5, 40)
	position_camera()
	$ContainerService.setup_map(width, height)

func position_camera():
	$Camera2D.position = Vector2(width/2.0,height/2.0) * 31

func get_size():
	return Vector2(width, height)
