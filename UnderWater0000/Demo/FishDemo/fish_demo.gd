extends Node2D

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D
@onready var collision = $Area2D/CollisionShape2D

@export var tile_scene : PackedScene
@export var coral_scene : PackedScene
@export var fish_scene : PackedScene
@export var predator_scene : PackedScene
@export var debug_fish_scene : PackedScene
@export var debug_predator_scene : PackedScene

@export var with_structure = true
@export var height = 50
@export var width = 80
@export var blue_fish_count = 10
@export var clown_fish_count = 10
@export var orange_fish_count = 10
@export var predator_fish_count = 10
@export var debug_fish_count = 1
@export var debug_predator_fish_count = 1

var noise_seed = 0
var fish_list = []
var sprite_dic = {}

var fish_data = null

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var noise_offset = 10000

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	fish_data = DataService.get_fish_data()
	for type in fish_data:
		print(type)
		var type_dic = fish_data[type]
		for fish_group in type_dic:
			sprite_dic[fish_group] = load(type_dic[fish_group]["sprite_path"])
			
	noise_one.seed = noise_seed
	noise_two.seed = noise_seed + noise_offset
	$Area2D/Sprite2D.position = Vector2(width * 16, height * 16)
	$Area2D/Sprite2D.scale = Vector2((width), (height))
	spawn_walls()
	add_points_to_path()
	$Camera2D.position = Vector2(width * 16, height * 16)
	spawn_fish(fish_scene, "BLUE", blue_fish_count, sprite_dic["BLUE"])
	spawn_fish(fish_scene, "CLOWN", clown_fish_count, sprite_dic["CLOWN"])
	spawn_fish(fish_scene,"ORANGE", orange_fish_count, sprite_dic["ORANGE"])
	spawn_fish(debug_fish_scene,"BLUE", debug_fish_count, sprite_dic["BLUE"])
	spawn_fish(predator_scene,"PIRANHA", predator_fish_count, sprite_dic["PIRANHA"])
	spawn_fish(debug_predator_scene,"PIRANHA", debug_predator_fish_count, sprite_dic["PIRANHA"])
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("left_mouse_button"): # Spawn coral at mouse position
#		var mouse_pos = get_global_mouse_position()
#		var new_tile = coral_scene.instantiate()
#		new_tile.position = mouse_pos
#		add_child(new_tile)
		pass
	if Input.is_action_just_pressed("right_mouse_button"): # Spawn obstacle at mouse position
		var mouse_pos = get_global_mouse_position()
		var new_tile = tile_scene.instantiate()
		new_tile.position = mouse_pos
		add_child(new_tile)

func add_points_to_path():
	var offset = 8
	path.curve.add_point(Vector2(32 * offset,32 * offset))
	path.curve.add_point(Vector2(32 * (width - 1) - 32 * offset, 32 * offset))
	path.curve.add_point(Vector2(32 * (width - 1) - 32 * offset, 32 * (height - 1) - 32 * offset))
	path.curve.add_point(Vector2(32 * offset, 32 * (height - 1) - 32 * offset))
	path.curve.add_point(Vector2(32 * offset, 32 * offset))

func spawn_walls():
	for y in range(height):
		for x in range(width):
			if y == 0 or y == height-1:
				var new_tile = tile_scene.instantiate()
				new_tile.position = Vector2(x * 32,y * 32)
				add_child(new_tile)
			elif x == 0 or x == width-1:
				var new_tile = tile_scene.instantiate()
				new_tile.position = Vector2(x * 32,y * 32)
				add_child(new_tile)
	if with_structure:
		var jumper = 5
		var ground_jumper = 2
		var ground_start = 5
		for x in range(width):
			var ground = (noise_one.get_noise_2d(x * ground_jumper, 0) + 1) * 0.5 * ground_start
			for y in range(ground, height):
				var noise_value_1 = (noise_one.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
				var noise_value_2 = (noise_two.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
				#var higherY = float(_y - y) / _y * 0.05
				if (noise_value_1 > 0.5 and noise_value_2 > 0.2):
					var new_tile = tile_scene.instantiate()
					new_tile.position = Vector2(x * 32,y * 32)
					add_child(new_tile)
	

func spawn_fish(input, type, size, other_sprite = null):
	for i in range(size):
		var random_float = rng.randf_range(0,1)
		path_follow.progress_ratio = random_float
		var fish = input.instantiate()
		fish.initialize_fish(type)
		if other_sprite != null:
			fish.set_sprite(other_sprite)
		var direction = path_follow.rotation + PI /2
		direction += randf_range(-PI / 4, PI / 4)
		fish.rotation =  direction
		fish.position = path_follow.position
		add_child(fish)

func _on_fish_spawner_timeout():
	pass # Replace with function body.

func _on_special_fish_spawner_timeout():
	pass # Replace with function body.
