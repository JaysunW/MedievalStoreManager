extends Node2D

@export var alge_scene : PackedScene
@export var tile_scene : PackedScene
var rng = RandomNumberGenerator.new()
var noise_one= FastNoiseLite.new()
var noise_seed = 10000
var noise_count = 0
var alge_list = []
var alge_length = 0.4
var max_length = 10
var alge_count = 3
var tile = null

func _ready():
	#alge_list = $Rigids.get_children()
	noise_one.seed = noise_seed
	spawn_alge(max_length)

func _process(delta):
	for j in range(alge_list.size()):
		for i in range(alge_list[j].size()):
			var val = noise_one.get_noise_2d(j * 5, (i + noise_count) * 4) * 16
			alge_list[j][i].apply_force(Vector2(val,0))
		noise_count += 1
	if noise_count >= 10000: noise_count = 0
	
func set_spawntile(spawntile):
	tile = spawntile

func spawn_alge(size):
	# Following just for Demo purpose:
#	var tile = tile_scene.instantiate()
#	add_child(tile)
#	tile.position = Vector2(250,150)
	for j in alge_count:
		var local_alge_list = []
		var offset = 32/3/2 * - (j*2-alge_count+1)
		var size_offset = rng.randi_range(size/2, size)
		var previous_alge = null
		for i in range(size_offset):
			var current_alge = alge_scene.instantiate()
			local_alge_list.append(current_alge)
			add_child(current_alge)
			change_alge_length(current_alge, alge_length)
			if i == size_offset-1: current_alge.gravity_scale = -0.3
			if i != 0:
				current_alge.position = previous_alge.position + Vector2(0,-32 * alge_length)
				current_alge.get_node("Joint").set_node_b(previous_alge.get_path())
			else:
				current_alge.position = tile.position + Vector2(offset,-20)
				current_alge.get_node("Joint").set_node_b(tile.get_path())
			previous_alge = current_alge
		alge_list.append(local_alge_list)
		
func change_alge_length(alge, length):
	alge.get_node("Collision").scale = Vector2.ONE * length
	alge.get_node("Sprite").scale = Vector2.ONE * length
	alge.get_node("Joint").position = alge.get_node("Joint").position * length
