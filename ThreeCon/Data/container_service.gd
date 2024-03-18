extends Node2D

@export var container : PackedScene
@export var content : PackedScene
@export var normal_generation = true

static var map = {}


var moved_position_list = []

var all_container_full = true
var _width = 0
var _height = 0
var content_list = ["blue", "green", "orange", "purple", "red"]
var fill_direction_list = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
var rng = RandomNumberGenerator.new()
var filling = false

func _process(_delta):
	if not filling:
		if Input.is_action_just_pressed("r"):
			debug_randomize_content_of_map()
			pass
		if Input.is_action_just_pressed("v"):
			debug_mark_all_connections()
			pass
		if Input.is_action_just_pressed("y"):
			debug_show_content_all_container()
			pass
		if Input.is_action_just_pressed("e"):
			#delete_all_connections()
			pass
		if Input.is_action_just_pressed("t"):
			fill_empty_container()
			pass
			
func _delete_all_connections():
	var list_of_connections = get_connections_in_map()
	for connection in list_of_connections:
		for pos in connection:
			var current_container = map[pos]
			if connection.size() == 4 and moved_position_list.has(pos):
				current_container.delete_content()
				if is_horizontal_connection(connection):
					current_container.set_content(create_special_content("VERTICAL", pos))
				else:
					current_container.set_content(create_special_content("HORIZONTAL", pos))
			elif current_container.has_content():
				current_container.delete_content()
	if list_of_connections.size() > 0:
		all_container_full = false
		$FillContainerTimer.start()
		
func delete_all_connections():
	var list_of_connections = get_connections_in_map()
	for connection in list_of_connections:
		var special_content_position = null
		var special_type = Enum.ContentType.UNKNOWN
		if has_number_of_connections(connection, 5):
			special_type = Enum.ContentType.SPECIAL
			for moved_pos in moved_position_list:
				if connection.has(moved_pos):
					special_content_position = moved_pos
			if not special_content_position:
				special_content_position = connection[rng.randi_range(0,connection.size()-1)]
			for pos in connection:
				var current_container = map[pos]
				current_container.delete_content()
				if special_content_position == pos:
					current_container.set_content(create_special_content(Enum.ContentType.SPECIAL, pos))
		elif has_number_of_connections(connection, 4):
			for moved_pos in moved_position_list:
				if connection.has(moved_pos):
					special_content_position = moved_pos
			if not special_content_position:
				special_content_position = connection[rng.randi_range(0,connection.size()-1)]
			for pos in connection:
				var current_container = map[pos]
				current_container.delete_content()
				if special_content_position == pos:
					if is_horizontal_connection(connection):
						current_container.set_content(create_special_content(Enum.ContentType.VERTICAL, pos))
					else:
						current_container.set_content(create_special_content(Enum.ContentType.HORIZONTAL, pos))
		else:
			for pos in connection:
				var current_container = map[pos]
				current_container.delete_content()
	if list_of_connections.size() > 0:
		all_container_full = false
		$FillContainerTimer.start()

func has_number_of_connections(list, number):
	var list_of_vert_hor_connections = []
	var vertical_list = []
	var horizontal_list = []
	for start in list:
		for pos in list:
			if start != pos:
				if start.x == pos.x:
					horizontal_list.append(pos)
				if start.y == pos.y:
					vertical_list.append(pos)
		horizontal_list.append(start)
		vertical_list.append(start)
		if horizontal_list.size() >= number or vertical_list.size() >= number:
			return true
		horizontal_list.clear()
		vertical_list.clear()
	return false

func is_horizontal_connection(connection):
	var start_vec = connection[0]
	var sum_vec = Vector2.ZERO
	for pos in connection:
		sum_vec += pos - start_vec
	return abs(sum_vec.x) > abs(sum_vec.y)

func fill_empty_container():
	all_container_full = true
	var switch_dic = {}
	for x in _width:
		for y in _height:
			var grid_position = Vector2(x,y)
			var current_container = map[grid_position]
			if not current_container.has_content():
				all_container_full = false
				var fill_direction = current_container.get_fill_direction()
				var other_position = grid_position + fill_direction
				if is_position_in_grid(other_position):
					if map[other_position].has_content():
						switch_dic[other_position] = grid_position
				else:
					var new_content = create_random_content(other_position)
					current_container.set_content(new_content)
					new_content.set_goal_position(current_container.position)
	for key in switch_dic:
		switch_content(key, switch_dic[key])
		
func setup_map(width, height):
	_width = width
	_height = height
	create_map()

func create_map():
	for y in range(_height):
		for x in range(_width):
			var grid_position = Vector2(x, y)
			var new_container = create_container(grid_position)
			var new_content = create_content(grid_position)
			new_container.set_content(new_content)
			map[grid_position] = new_container

func create_container(grid_position):
	var new_container = container.instantiate()
	add_child(new_container)
	new_container.position = grid_position * 32
	new_container.set_grid_position(grid_position)
	if grid_position.x > 0 and grid_position.y > 3 and grid_position.y <=5:
		new_container.set_fill_direction(Vector2.LEFT)
		new_container.highlight(0,0,1)
	new_container.get_content_moved_signal().connect(move_content)
	return new_container

func create_content(grid_position):
	var new_content = content.instantiate()
	add_child(new_content)
	new_content.position = grid_position * 32
	if normal_generation:
		new_content.set_content_data(generate_normal_content_data(grid_position))
	else:
		if debug_is_in_position(grid_position) :
			new_content.set_content_data(get_certain_content_data(1))
		else:
			new_content.set_content_data(get_modulo_content_data(grid_position.x,grid_position.y))
	return new_content

func create_random_content(grid_position):
	var new_content = content.instantiate()
	add_child(new_content)
	new_content.position = grid_position * 32
	new_content.set_content_data(get_random_content_data())
	return new_content

func generate_normal_content_data(grid_position):
	if grid_position.x >= 2  or grid_position.y >= 2 :
		var countainer_left = null
		var countainer_above = null
		var current_content = get_random_content_data()
		if grid_position.x >= 2:
			countainer_left = map[grid_position + Vector2(-1, 0)]
		if grid_position.y >= 2:
			countainer_above = map[grid_position + Vector2(0, -1)]
		if countainer_left and countainer_above:
			var type_left = countainer_left.get_content().get_content_data().get_type()
			var type_above = countainer_above.get_content().get_content_data().get_type()
			while current_content.get_type() == type_above or current_content.get_type() == type_left:
				current_content = get_random_content_data()
		elif countainer_left:
			var type_left = countainer_left.get_content().get_content_data().get_type()
			while current_content.get_type() == type_left:
				current_content = get_random_content_data()
		elif countainer_above:
			var type_above = countainer_above.get_content().get_content_data().get_type()
			while current_content.get_type() == type_above:
				current_content = get_random_content_data()
		return current_content
	else:
		return get_random_content_data()

func get_random_content_data():
	var num = rng.randi_range(0,content_list.size()-1)
	var sprite_name = content_list[num]
	var new_content = container_content.new(load("res://Assets/Content/gem_" + sprite_name + ".png"), Enum.ContentType.values()[num])
	return new_content

func get_modulo_content_data(x,y):
	var num = int(x + y) % content_list.size()
	var sprite_name = content_list[num]
	var new_content = container_content.new(load("res://Assets/Content/gem_" + sprite_name + ".png"), Enum.ContentType.values()[num])
	return new_content

func get_certain_content_data(number):
	var num = clamp(number,0,content_list.size())
	var sprite_name = content_list[num]
	var new_content = container_content.new(load("res://Assets/Content/gem_" + sprite_name + ".png"), Enum.ContentType.values()[num])
	return new_content
	
func create_special_content(type, grid_position):
	var new_content = content.instantiate()
	add_child(new_content)
	new_content.position = grid_position * 32
	var new_content_data = null
	match type:
		Enum.ContentType.HORIZONTAL:
			new_content_data = container_content.new(load("res://Assets/Content/content_special_horizontal.png"), type)
		Enum.ContentType.VERTICAL:
			new_content_data = container_content.new(load("res://Assets/Content/content_special_vertical.png"), type)
		Enum.ContentType.SPECIAL:
			new_content_data = container_content.new(load("res://icon.svg"), type)
	new_content.set_content_data(new_content_data)
	return new_content

func get_connections_in_map():
	var vert_connection_list = get_vertival_connections()
	var hor_connection_list = get_horizontal_connections()
	for hor_connection in hor_connection_list:
		vert_connection_list.append(hor_connection)
	return vert_connection_list

func get_vertival_connections():
	var output_connection = []
	var possible_connection = []
	var current_type = null
	for x in range(_width):
		possible_connection = []
		for y in range(_height):
			var grid_position = Vector2(x,y)
			var current_container = map[grid_position]
			if current_container.has_content():
				var current_content = current_container.get_content()
				var content_data = current_content.get_content_data()
				if content_data.is_special():
					current_type = null
					possible_connection = []
				var type = content_data.get_type()
				if current_type == null:
					current_type = type
					possible_connection = [grid_position]
				elif current_type != type:
					if possible_connection.size() >= 3:
						output_connection.append(possible_connection)
					possible_connection = [grid_position]
					current_type = type
				else:
					possible_connection.append(grid_position)
			else:
				current_type = null
		if possible_connection.size() >= 3:
			output_connection.append(possible_connection)
		current_type = null
	return output_connection

func get_horizontal_connections():
	var output_connection = []
	var possible_connection = []
	var current_type = null
	for y in range(_height):
		possible_connection = []
		for x in range(_width):
			var grid_position = Vector2(x,y)
			var current_container = map[grid_position]
			if current_container.has_content():
				var current_content = current_container.get_content()
				var content_data = current_content.get_content_data()
				if content_data.is_special():
					current_type = null
					possible_connection = []
				var type = content_data.get_type()
				if current_type == null:
					current_type = type
					possible_connection = [grid_position]
				elif current_type != type:
					if possible_connection.size() >= 3:
						output_connection.append(possible_connection)
					possible_connection = [grid_position]
					current_type = type
				else:
					possible_connection.append(grid_position)
			else:
				current_type = null
		if possible_connection.size() >= 3:
			output_connection.append(possible_connection)
		current_type = null
	return output_connection

func get_special_connections_in_map():
	var vertical_connections = get_vertival_connections()
	var horizontal_connections = get_horizontal_connections()
	var connections = []
	for hor_con_list in horizontal_connections:
		for hor_pos in hor_con_list:
			for vert_con_list in vertical_connections:
				if vert_con_list.has(hor_pos):
					var temporary_list = vert_con_list + []
					temporary_list.erase(hor_pos)
					temporary_list.append_array(hor_con_list)
					connections.append(temporary_list)
					break
	return connections

func check_for_connections(first_grid_pos, second_grid_pos):
	var first_container = map[first_grid_pos]
	var second_container = map[second_grid_pos]
	var first_content = first_container.get_content()
	var second_content = second_container.get_content()
	if first_content and second_container and second_content:
		first_container.set_content(second_content)
		second_container.set_content(first_content)
		var connections = get_connections_in_map().size()
		first_container.set_content(first_content)
		second_container.set_content(second_content)
		return connections > 0
	return false
	
func move_content(grid_position, move_dir):
	if all_container_full:
		var other_grid_position = grid_position + move_dir
		if is_position_in_grid(other_grid_position) and check_for_connections(grid_position, other_grid_position):
			moved_position_list.clear()
			moved_position_list.append(grid_position)
			moved_position_list.append(other_grid_position)
			switch_content(grid_position, other_grid_position)
			all_container_full = false
			$DestroyConnectionsTimer.start()
		
func is_position_in_grid(grid_pos):
	return (0 <= grid_pos.x and grid_pos.x < _width) and (0 <= grid_pos.y and grid_pos.y < _height)

func switch_content(first_grid_pos, second_grid_pos):
	var first_container = map[first_grid_pos]
	var second_container = map[second_grid_pos]
	var first_content = first_container.get_content()
	var second_content = second_container.get_content()
	if first_content and second_container:
		if second_content:
			first_container.set_content(second_content)
			second_container.set_content(first_content)
			first_content.set_goal_position(second_container.position)
			second_content.set_goal_position(first_container.position)
		else:
			second_container.set_content(first_content)
			first_container.set_content(null)
			first_content.set_goal_position(second_container.position)

func debug_show_content_all_container():
	for x in _width:
		for y in _height:
			var grid_position = Vector2(x, y)
			var current_container = map[grid_position]
			if current_container.has_content():
				var current_content = current_container.get_content()
				var content_data = current_content.get_content_data()
				var type = content_data.get_type()
				match type:
					0:
						current_container.highlight(0,0,1)
					1:
						current_container.highlight(0,1,0)
					2:
						current_container.highlight(1,0.5,0)
					3:
						current_container.highlight(1,0,1)
					4:
						current_container.highlight(1,0,0)
					_:
						print("Wrong : ", self)
			else:
				current_container.highlight(0,0,0)

func debug_mark_all_connections():
	var list_of_connections = get_connections_in_map()
	for x in _width:
		for y in _height:
			var grid_position = Vector2(x, y)
			var current_container = map[grid_position]
			current_container.highlight(0,0,0)
	for connection in list_of_connections:
		for pos in connection:
			map[pos].highlight(1,0,0)
			
func debug_is_in_position(pos):
	var list = [[6,3,7],[7,5,6],[8,5,6]]
	for test_pos in list:
		if pos.y == test_pos[0] and pos.x >= test_pos[1] and pos.x < test_pos[2]:
			return true
	return false
	
func debug_randomize_content_of_map():
	for y in range(_height):
		for x in range(_width):
			map[Vector2(x,y)].delete_content()
			var new_content = create_content(Vector2(x,y))
			map[Vector2(x,y)].set_content(new_content)
	
func _on_destroy_connections_timer_timeout():
	delete_all_connections()
	moved_position_list.clear()
	
func _on_fill_container_timer_timeout():
	fill_empty_container()
	if not all_container_full:
		$FillContainerTimer.start()
	else:
		delete_all_connections()
