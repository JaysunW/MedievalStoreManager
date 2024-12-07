extends Node2D

@onready var change_color_timer = $ChangeColorTimer

@export var shelf_sprite_list : Array[Sprite2D]

@export var marker_list : Array[Marker2D]
var marker_start_position = {}

var top_list = []
var middle_list = []
var bottom_list = []

var is_flashing_color = false

var current_orientation = 0 

func _ready() -> void:
	for marker in marker_list:
		marker_start_position[marker] = marker.position

func change_color(color, change_alpha=false):
	if not is_flashing_color:
		for sprite in shelf_sprite_list:
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
		for sprite in shelf_sprite_list:
			sprite.z_index = 0
		match current_orientation:
			Utils.Orientation.EAST:
				for marker in marker_list:
					marker.position = marker_start_position[marker] + Vector2(-6, -10)
			Utils.Orientation.WEST:
				for marker in marker_list:
					marker.position = marker_start_position[marker] + Vector2(6, -10)
	else:
		change_color(Color(1,1,1,0.6))
		for sprite in shelf_sprite_list:
			sprite.z_index = 2
		
func rotate_sprite(next_frame):
	current_orientation = next_frame
	for sprite in shelf_sprite_list:
		if next_frame < sprite.hframes:
			sprite.frame = next_frame
		else: 
			print_debug("next frame is not small enough")

func offset_sprite(offset_vector):
	for sprite in shelf_sprite_list:
		sprite.position = offset_vector
	
func prepare_filling_building(input_content_data):
	var max_value = input_content_data["max_amount"]
	var sprite_path = input_content_data["sprite_path"]
	
	var top : int = floor(max_value / 3) + max_value % 3
	var middle : int = floor(max_value / 3)
	var bottom : int = floor(max_value / 3)
	
	var placement_vector = Vector2.ZERO
	if current_orientation == Utils.Orientation.SOUTH || current_orientation == Utils.Orientation.NORTH:
		placement_vector = Vector2( 1, 0)
	elif current_orientation == Utils.Orientation.EAST || current_orientation == Utils.Orientation.WEST:
		placement_vector = Vector2( 0, 1)
	var sprite_list = []
	
	top_list = create_shelf_filling(top, placement_vector, sprite_path)
	middle_list = create_shelf_filling(middle, placement_vector, sprite_path)
	bottom_list = create_shelf_filling(bottom, placement_vector, sprite_path)
	
	var shelf_list = [top_list, middle_list, bottom_list]
	
	for i in range(len(shelf_list)):
		for sprite in shelf_list[i]:
			marker_list[i].add_child(sprite)
			
	top_list[0].visible = true
	
func show_filling_building(input_content_data):
	var max_value = input_content_data["max_amount"]
	var value = input_content_data["amount"]
	
	var top : int = floor(max_value / 3) + max_value % 3
	var middle : int = floor(max_value / 3)
	
	if value <= top:
		top_list[value - 1].visible = true
		if value + 1 > top:
			middle_list[0].visible = false
		else:
			top_list[value].visible = false
	elif value <= top + middle:
		middle_list[value - top - 1].visible = true
		if value + 1 > top + middle:
			bottom_list[0].visible = false
		else:
			middle_list[value - top].visible = false
	elif value <= max_value:
		bottom_list[value - top - middle - 1].visible = true
		if value != max_value:
			bottom_list[value - top - middle].visible = false

func create_shelf_filling(shelf_amount, placement_vector, sprite_path):
	var sprite_list = []
	for i in range(shelf_amount):
		var sprite = Sprite2D.new()
		sprite.visible = false
		var start_offset = 10
		var start_position = - placement_vector * start_offset
		var random_offset = Vector2( placement_vector.y, placement_vector.x) * Global.rng.randi_range(1, 2)
		if current_orientation == Utils.Orientation.WEST:
			random_offset = random_offset * -1
		sprite.texture = Loader.shop_item_texture(sprite_path, true)
		sprite.position = start_position + placement_vector * int(remap(i, 0, shelf_amount-1, 0, start_offset * 2)) - random_offset
		sprite_list.append(sprite)
	return sprite_list

func is_being_emptied():
	for sprite in top_list:
		sprite.queue_free()
	for sprite in middle_list:
		sprite.queue_free()
	for sprite in bottom_list:
		sprite.queue_free()

func _on_change_color_timer_timeout() -> void:
	is_flashing_color = false
	change_color(Color(1,1,1))
