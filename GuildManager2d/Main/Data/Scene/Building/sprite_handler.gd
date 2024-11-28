extends Node2D

@onready var change_color_timer = $ChangeColorTimer

@export var building_sprite : Sprite2D
@export var fill_sprite : Sprite2D
@export var fill_sprite_count = 0

var is_flashing_color = false

func _ready() -> void:
	fill_sprite_count = fill_sprite.hframes

func change_color(color, change_alpha=false):
	if not is_flashing_color:
		if change_alpha:
			building_sprite.modulate = color
		else:
			building_sprite.modulate = Color(color.r,color.g,color.b, building_sprite.modulate.a)

func flash_color(color, flash_time = 0.1, change_alpha = false):
	if not is_flashing_color:
		is_flashing_color = true
		change_color(color, change_alpha)
		change_color_timer.start(flash_time)

func should_prepare_building(should_prepare):
	if should_prepare:
		change_color(Color(1,1,1,1))
		building_sprite.z_index = 0
	else:
		change_color(Color(1,1,1,0.6))
		building_sprite.z_index = 2
		
func rotate_sprite(next_frame):
	if next_frame < building_sprite.hframes:
		building_sprite.frame = next_frame

func offset_sprite(offset_vector):
	building_sprite.position = offset_vector
	
func show_filling_building(input_content_data):
	var max_value = input_content_data["max_amount"]
	var value = input_content_data["amount"]
	var color_list = input_content_data["average_color"]
	var average_item_color = Color.WHITE
	print(color_list)
	if len(color_list) == 3:
		average_item_color = Color(color_list[0],color_list[1],color_list[2])
	fill_sprite.modulate = average_item_color
	if value < max_value:
		fill_sprite.frame = ceil(remap(value, 0, max_value, 0, fill_sprite_count-1))
	else:
		fill_sprite.frame = floor(remap(value, 0, max_value, 0, fill_sprite_count-1))

func is_being_emptied():
	fill_sprite.frame = 0

func _on_change_color_timer_timeout() -> void:
	is_flashing_color = false
	change_color(Color(1,1,1))
