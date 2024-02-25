extends Node2D

@export var fish_scene : PackedScene
@export var predator_scene : PackedScene
@export var special_fish_scene : PackedScene
@export var special_predator_scene : PackedScene

var blue_sprite = preload("res://Assets/Fish/BlueFish.png")
var clown_sprite = preload("res://Assets/Fish/clownfish.png")
var piranha_sprite = preload("res://Assets/Fish/Piranha.png")
var orange_sprite = preload("res://Assets/Fish/OrangeFish.png")

@onready var spawn_timer = $FishSpawnTimer
@onready var despawn_timer = $FishDespawnTimer

var noise_seed = 0
var fish_list = []
var to_delete_list = []
var spawn_list = []

var noise_one= FastNoiseLite.new()
var noise_two = FastNoiseLite.new()
var noise_offset = 10000

var spawn_time_max = 20
var spawn_time_min = 8

var rng = RandomNumberGenerator.new()

class SpawnFishType:
	var scene = null
	var type = null
	var size = 0
	var sprite = null
	
	func _init(_scene, _type, _size, _sprite = null):
		scene = _scene
		type = _type
		size = _size
		sprite = _sprite

func _ready():
	print(spawn_list.size())
	for i in range(5):
		var size = i + 5
		spawn_list.append(SpawnFishType.new(fish_scene, "BLUE", size,blue_sprite))
		spawn_list.append(SpawnFishType.new(fish_scene, "CLOWN", size,clown_sprite))
		spawn_list.append(SpawnFishType.new(fish_scene, "ORANGE", size,orange_sprite))
	for i in range(2):
		var size = i + 1
		spawn_list.append(SpawnFishType.new(fish_scene, "PIRANHA", size,piranha_sprite))
	print(spawn_list.size())
	
func _process(delta):
	#$"../GridService".get_new_fish_position()
	pass

func spawn_fish(input, type, size, other_sprite = null):
	for i in range(size):
		var pos = $"../GridService".get_new_fish_position()
		if not pos:
			return
		var new_fish = input.instantiate()
		new_fish.initialize_fish(type)
		if other_sprite:
			new_fish.set_sprite(other_sprite)
		add_child(new_fish)
		new_fish.position = pos
		fish_list.append(new_fish)

func _on_fish_spawn_timer_timeout():
	spawn_timer.wait_time = rng.randi_range(spawn_time_min,spawn_time_max)
	if fish_list.size() < 80 and spawn_list.size() > 0:
		var spawn_type = spawn_list[rng.randi_range(0, spawn_list.size()-1)]
		spawn_fish(spawn_type.scene,spawn_type.type, spawn_type.size, spawn_type.sprite)
	#search for free area around player and spawn depending on y of position

func _on_fish_despawn_timer_timeout():
	for fish in fish_list:
		var chunk_pos = $"../GridService".get_chunk_position(fish.position)
		if not $"../GridService".get_loaded_chunks().has(chunk_pos):
			to_delete_list.append(fish)
	for fish in to_delete_list:
		fish_list.erase(fish)
		fish.queue_free()
	to_delete_list.clear()
	print("Despawned")
	pass # Replace with function body.
