extends Node2D

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D
@onready var collision = $Area2D/CollisionShape2D

@export var tile_scene : PackedScene
@export var fish_scene : PackedScene
@export var special_fish_scene : PackedScene
@export var height = 50
@export var width = 80
@export var normal_fish = 30
@export var special_fish = 2
@export var noise_seed : int = 000000

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var noise_offset = 10000

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	noise_one.seed = noise_seed
	noise_two.seed = noise_seed + noise_offset
	collision.position = Vector2(width* 32/2, height* 32/2)
	$Area2D/Sprite2D.position = Vector2(width* 32/2, height* 32/2)
	collision.scale = Vector2((width), (height))
	$Area2D/Sprite2D.scale = Vector2((width), (height))
	spawn_walls()
	add_points_to_path()
	$Camera2D.position = Vector2(width* 32/2, height* 32/2)
	spawn_at_random_position()
	spawn_test_fish()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("left_mouse_button"):
		var mouse_pos = get_global_mouse_position()
		var new_tile = tile_scene.instantiate()
		new_tile.position = mouse_pos
		add_child(new_tile)
		print(new_tile.position)

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
	var jumper = 5
	var ground_jumper = 2
	var ground_start = 5
	for x in range(width):
		var ground = (noise_one.get_noise_2d(x * ground_jumper, 0) + 1) * 0.5 * ground_start
		for y in range(ground, height):
			var noise_value_1 = (noise_one.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			var noise_value_2 = (noise_two.get_noise_2d(x * jumper, y * jumper) + 1) * 0.5
			#var higherY = float(_y - y) / _y * 0.05
			var y_offset = 5
			var noise_around_zero = noise_value_1 * y_offset - y_offset
			if (noise_value_1 > 0.6 and noise_value_2 > 0.2):
				var new_tile = tile_scene.instantiate()
				new_tile.position = Vector2(x * 32,y * 32)
				add_child(new_tile)
				
func add_points_to_path():
	var offset = 8
	path.curve.add_point(Vector2(32 * offset,32 * offset))
	path.curve.add_point(Vector2(32 * (width - 1) - 32 * offset, 32 * offset))
	path.curve.add_point(Vector2(32 * (width - 1) - 32 * offset, 32 * (height - 1) - 32 * offset))
	path.curve.add_point(Vector2(32 * offset, 32 * (height - 1) - 32 * offset))
	path.curve.add_point(Vector2(32 * offset, 32 * offset))

func spawn_test_fish():
	for i in range(special_fish):
		var fish = special_fish_scene.instantiate()
		var direction = path_follow.rotation + PI /2
		direction += randf_range(-PI / 4, PI / 4)
		fish.rotation =  direction
		fish.position = Vector2(width* 32/2 + rng.randi_range( -4, 5)* 32, height* 32/2 + rng.randi_range( -4, 5)* 32)
		add_child(fish)

func spawn_at_random_position():
	for i in range(normal_fish):
		var random_float = rng.randf_range(0,1)
		path_follow.progress_ratio = random_float
		var fish = fish_scene.instantiate()
		var direction = path_follow.rotation + PI /2
		direction += randf_range(-PI / 4, PI / 4)
		fish.rotation =  direction
		fish.position = path_follow.position
		add_child(fish)

func _on_fish_spawner_timeout():
	spawn_at_random_position()
	pass # Replace with function body.

func _on_special_fish_spawner_timeout():
	spawn_test_fish()
	pass # Replace with function body.

func _on_area_2d_area_exited(area):
	if area.get_groups().has("Fish"):
		var fish_pos = area.get_parent().global_position
		if fish_pos.y > height * 30 or fish_pos.y < 32 * 2:
			area.get_parent().global_position = Vector2(clamp(fish_pos.x,32, (width * 31)), abs((height * 31) - fish_pos.y))
		if fish_pos.x > width * 30 or fish_pos.x < 32 * 2:
			area.get_parent().global_position = Vector2(abs((width * 31) - fish_pos.x), clamp(fish_pos.y,32, (height * 31)))
