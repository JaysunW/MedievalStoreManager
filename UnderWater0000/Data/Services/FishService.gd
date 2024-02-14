extends Node2D

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D
@onready var collision = $Area2D/CollisionShape2D

@export var tile_scene : PackedScene
@export var coral_scene : PackedScene
@export var fish_scene : PackedScene
@export var predator_scene : PackedScene
@export var special_fish_scene : PackedScene
@export var special_predator_scene : PackedScene

var noise_seed = 0
var fish_list = []

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var noise_offset = 10000

var rng = RandomNumberGenerator.new()

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
