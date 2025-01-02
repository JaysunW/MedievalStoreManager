extends Sprite2D

@onready var change_color_timer = $ChangeColorTimer

var is_flashing_color = false

var current_orientation = 0 

func rotate_sprite(next_frame):
	current_orientation = next_frame
	if next_frame < hframes:
		frame = next_frame
	else: 
		print_debug("next frame is not small enough")

func should_prepare_building(should_prepare):
	if should_prepare:
		change_color(Color(1,1,1,1))
		z_index = 0
		material = null
	else:
		change_color(Color(1,1,1,0.6))
		z_index = 2
		material = ShaderMaterial.new()
		material.shader = get_parent().building_shader

func change_color(color, change_alpha=false):
	if not is_flashing_color:
		if change_alpha:
			modulate = color
		else:
			modulate = Color(color.r,color.g,color.b, modulate.a)

func flash_color(color, flash_time = 0.1, change_alpha = false):
	if not is_flashing_color:
		is_flashing_color = true
		change_color(color, change_alpha)
		change_color_timer.start(flash_time)
