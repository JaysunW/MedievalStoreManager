extends Node2D

@export var fish_scene : PackedScene
@export var predator_scene : PackedScene
@export var special_fish_scene : PackedScene
@export var special_predator_scene : PackedScene
@export var caught_particles_scene : PackedScene

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
var fish_data = {}

class SpawnFishType:
	var scene = null
	var dic = {}
	var count = 0
	
	func _init(_scene, _dic, _count):
		scene = _scene
		dic = _dic
		count = _count

func _ready():
	fish_data = DataService.get_fish_data()
	var prey_dic = fish_data["PREY"]
	var predator_dic = fish_data["PREDATOR"]
	for prey in prey_dic:
		for i in range(5 - prey_dic[prey]["size"] * 2):
			spawn_list.append(SpawnFishType.new(fish_scene, prey_dic[prey], i + 2))
	for predator in fish_data["PREDATOR"]:
		for i in range(3 - predator_dic[predator]["size"]):
			spawn_list.append(SpawnFishType.new(predator_scene, predator_dic[predator], i + 1))
	
func _process(_delta):
	pass

func fish_got_caught(fish):
	get_gold_for_fish(fish)
	fish_list.erase(fish)
	fish.queue_free()

func get_gold_for_fish(fish):
	var prey_data = fish_data["PREY"]
	var value = 0
	if prey_data.keys().has(fish.get_type()):
		value = prey_data[fish.get_type()]["value"]
	else:
		value = fish_data["PREDATOR"][fish.get_type()]["value"]
	GoldService.add_gold(value - rng.randi_range(0,value/4))
	
func _on_fish_spawn_timer_timeout():
	spawn_timer.wait_time = 2# rng.randi_range(spawn_time_min,spawn_time_max)
	if fish_list.size() < 80 and spawn_list.size() > 0:
		var pos = $"../GridService".get_new_fish_position()
		if not pos:
			return
		var border_area = $"../GridService".get_border_area(pos.x/32, (pos.y/32) - 2, true)
		print("Border_area: ", border_area, self)
		var fish_to_spawn = decide_fish(border_area)
		var spawn_count = 0
		if fish_to_spawn["predator"]:
			spawn_count = rng.randi_range(1,3)
		else:
			spawn_count = rng.randi_range(2,5)
		spawn_fish( pos, get_fish_scene(fish_to_spawn), fish_to_spawn, spawn_count)
	#search for free area around player and spawn depending on y of position

func decide_fish(border_id):
	var fish_to_look_at = []
	var rarity_max = 10
	var rarity_sum = 0
	var random_int = rng.randi_range(0,99)
	for type in fish_data:
		for group in fish_data[type]:
			var fish_dic = fish_data[type][group]
			var list = fish_dic["border_id_list"]
			if list.has(float(border_id)):
				fish_to_look_at.append(fish_dic)
				rarity_sum += float(rarity_max - fish_dic["rarity"])
	var bottom_border_percent = 0
	for fish_dic in fish_to_look_at:
		var area_border_percent = (rarity_max - fish_dic["rarity"])*100/rarity_sum
		var upper_border_percent = bottom_border_percent + area_border_percent
		if bottom_border_percent <= random_int and random_int < upper_border_percent:
			return fish_dic
		bottom_border_percent = upper_border_percent
	print("Something went wrong with the gem decision, maybe faulty rarity of gems : DropService ")
	print("Should be 100: " + str(bottom_border_percent) + " gem_to_look size: " + str(fish_to_look_at.size()) + " randint: "+str(random_int) )
	print("Border_idx :" + str(border_id))
	return null

func get_fish_scene(fish_dic):
	if fish_dic["predator"]:
		return predator_scene
	else:
		return fish_scene

func spawn_fish(pos, scene, fish_dic, count):
	for i in range(count):
		var new_fish = scene.instantiate()
		add_child(new_fish)
		new_fish.initialize_fish(fish_dic["type"])
		new_fish.set_sprite(load(fish_dic["sprite_path"]))
		new_fish.set_size(fish_dic["size"])
		new_fish.position = pos
		new_fish.get_caught_signal().connect(fish_got_caught)
		fish_list.append(new_fish)

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
