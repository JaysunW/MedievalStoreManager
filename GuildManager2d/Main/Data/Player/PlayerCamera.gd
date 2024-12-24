extends Camera2D

@export_category("Follow Character")
@export var player : CharacterBody2D
@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8

var offset_vector = Vector2.ZERO

func _ready() -> void:
	SignalService.camera_offset.connect(set_offset_vector)

func set_offset_vector(input : Vector2):
	offset_vector = input

func _process(_delta):
	if player:
		var camera_position : Vector2
		
		if smoothing_enabled:
			var weight : float = float(11 - smoothing_distance) / 100
			camera_position = lerp(global_position, player.global_position + offset_vector, weight)
		else:
			camera_position = player.global_position
		
		global_position = camera_position
