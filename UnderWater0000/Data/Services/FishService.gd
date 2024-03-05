extends Node2D

@export var fish_scene : PackedScene
@export var predator_scene : PackedScene
@export var special_fish_scene : PackedScene
@export var special_predator_scene : PackedScene

var blue_sprite = preload("res://Assets/Fish/blue_fish.png")
var clown_sprite = preload("res://Assets/Fish/clown_fish.png")
var piranha_sprite = preload("res://Assets/Fish/piranha.png")
var orange_sprite = preload("res://Assets/Fish/orange_fish.png")

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
	var dic = {}
	var count = 0
	
	func _init(_scene, _dic, _count):
		scene = _scene
		dic = _dic
		count = _count

func _ready():
	var fish_data = DataService.get_fish_data()
	var prey_dic = fish_data["PREY"]
	var predator_dic = fish_data["PREDATOR"]
	for prey in prey_dic:
		print(prey)
		for i in range(5):
			spawn_list.append(SpawnFishType.new(fish_scene, prey_dic[prey], i + 2))
	for predator in fish_data["PREDATOR"]:
		for i in range(2):
			spawn_list.append(SpawnFishType.new(predator_scene, predator_dic[predator], i + 1))
	
func _process(_delta):
	pass

func spawn_fish(scene, data_dic, count):
	var pos = $"../GridService".get_new_fish_position()
	if not pos:
		return
	for i in range(count):
		var new_fish = scene.instantiate()
		new_fish.initialize_fish(data_dic["type"])
		new_fish.set_sprite(load(data_dic["sprite_path"]))
		new_fish.position = pos
		add_child(new_fish)
		new_fish.get_caught_signal().connect(fish_got_caught)
		fish_list.append(new_fish)

func fish_got_caught(type):
	print(type, " caught : fish_service")

func _on_fish_spawn_timer_timeout():
	spawn_timer.wait_time = 2# rng.randi_range(spawn_time_min,spawn_time_max)
	if fish_list.size() < 80 and spawn_list.size() > 0:
		var spawn_type = spawn_list[rng.randi_range(0, spawn_list.size()-1)]
		spawn_fish(spawn_type.scene,spawn_type.dic, spawn_type.count)
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
	pass # Replace with function body.
