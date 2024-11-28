extends Node2D

@export var cloth_animation: AnimatedSprite2D

@export var animation_player_list : Array[AnimatedSprite2D]
@export var cloth_color : Color
@export var is_default_color = false

func _ready() -> void:
	set_color(Color.AQUA)
	if is_default_color:
		set_default_color()
	for animation_player in animation_player_list:
		animation_player.play()

func set_animation(animation_state):
	for animation_player in animation_player_list:
		animation_player.animation = animation_state

func set_flip_h(input):
	for animation_player in animation_player_list:
		animation_player.flip_h = input

func set_color(color):
	cloth_animation.modulate = color

func set_default_color():
	cloth_animation.modulate = cloth_color

func play_animation():
	for animation_player in animation_player_list:
		if not animation_player.is_playing():
			animation_player.play()

func stop_animation():
	for animation_player in animation_player_list:
		animation_player.stop()
