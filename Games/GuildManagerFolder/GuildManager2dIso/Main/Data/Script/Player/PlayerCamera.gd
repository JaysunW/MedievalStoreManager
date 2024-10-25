extends Camera2D

@export_category("Follow Character")
@export var player : CharacterBody2D
@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1,10) var smoothing_distance : int = 8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player:
		var camera_position : Vector2
		
		if smoothing_enabled:
			var weight : float = float(11 - smoothing_distance) / 100
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position
		
		global_position = camera_position
