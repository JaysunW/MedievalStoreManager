extends Node2D

@onready var change_color_timer = $ChangeColorTimer

@export var shelving_sprite_list : Array[Sprite2D]
@export var item_position_marker : Marker2D
@export var max_item_show_amount : int= 10
@export var limit_show_amount : bool = false 

var marker_start_position : Vector2

var sprite_list = []

var is_flashing_color = false

var current_orientation = 0 

func _ready() -> void:
	marker_start_position = item_position_marker.position

func change_color(color, change_alpha=false):
	if not is_flashing_color:
		for sprite in shelving_sprite_list:
			if change_alpha:
				sprite.modulate = color
			else:
				sprite.modulate = Color(color.r,color.g,color.b, sprite.modulate.a)

func flash_color(color, flash_time = 0.1, change_alpha = false):
	if not is_flashing_color:
		is_flashing_color = true
		change_color(color, change_alpha)
		change_color_timer.start(flash_time)

func should_prepare_building(should_prepare):
	if should_prepare:
		change_color(Color(1,1,1,1))
		for sprite in shelving_sprite_list:
			sprite.z_index = 0
		match current_orientation:
			Utils.Orientation.EAST:
				item_position_marker.position = marker_start_position + Vector2(-6, -10)
			Utils.Orientation.WEST:
				item_position_marker.position = marker_start_position + Vector2(6, -10)
	else:
		change_color(Color(1,1,1,0.6))
		for sprite in shelving_sprite_list:
			sprite.z_index = 2
		
func rotate_sprite(next_frame):
	current_orientation = next_frame
	for sprite in shelving_sprite_list:
		if next_frame < sprite.hframes:
			sprite.frame = next_frame
		else: 
			print_debug("next frame is not small enough")

func offset_sprite(offset_vector):
	for sprite in shelving_sprite_list:
		sprite.position = offset_vector
	
func prepare_filling_building(input_content_data):
	var max_value = input_content_data["max_amount"]
	var sprite_path = input_content_data["sprite_path"]
	
	var placement_vector = Vector2.ZERO
	if current_orientation == Utils.Orientation.SOUTH || current_orientation == Utils.Orientation.NORTH:
		placement_vector = Vector2( 1, 0)
	elif current_orientation == Utils.Orientation.EAST || current_orientation == Utils.Orientation.WEST:
		placement_vector = Vector2( 0, 1)
	
	if limit_show_amount and max_value > max_item_show_amount:
		max_value = max_item_show_amount
		
	sprite_list = create_shelf_filling(max_value, placement_vector, sprite_path)
	
	for sprite in sprite_list:
		item_position_marker.add_child(sprite)
			
	sprite_list[0].visible = true
	
func show_filling_building(input_content_data):
	var max_value = input_content_data["max_amount"]
	var value = input_content_data["amount"]
	
	if limit_show_amount and max_value > max_item_show_amount:
		value = max(1, int(remap(value, 0, max_value, 0, max_item_show_amount)))
		max_value = max_item_show_amount
		
	if value - 1 < max_value:
		sprite_list[value - 1].visible = true
		if not value >= max_value:
			sprite_list[value].visible = false

func create_shelf_filling(shelf_amount, placement_vector, sprite_path):
	var output_list = []
	for i in range(shelf_amount):
		var sprite = Sprite2D.new()
		sprite.visible = false
		var start_offset = 10
		var start_position = - placement_vector * start_offset
		var random_offset = Vector2( placement_vector.y, placement_vector.x) * Global.rng.randi_range(1, 2)
		if current_orientation == Utils.Orientation.WEST:
			random_offset = random_offset * -1
		sprite.texture = Loader.shop_item_texture(sprite_path, true)
		if placement_vector.x == 0:
			random_offset *= int(remap(i, 0, shelf_amount-1, -5, 5))

		sprite.position = start_position + placement_vector * int(remap(i, 0, shelf_amount-1, 0, start_offset * 2)) - random_offset
		output_list.append(sprite)
	return output_list

func is_being_emptied():
	for sprite in sprite_list:
		sprite.queue_free()

func _on_change_color_timer_timeout() -> void:
	is_flashing_color = false
	change_color(Color(1,1,1))
