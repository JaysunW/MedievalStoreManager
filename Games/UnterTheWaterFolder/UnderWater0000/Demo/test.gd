extends Node2D

@export var alge_scene : PackedScene
@onready var used_tile = $"../Tile4"

@export var special_fish_scene : PackedScene
var test_fish = null
var spawned = false

func ready():
	pass
	
func spawn_fish(input, type, size, other_sprite = null):
	for i in range(size):
		var fish = input.instantiate()
		fish.initialize_fish(type)
		if other_sprite != null:
			fish.set_sprite(other_sprite)
		fish.position = Vector2.ZERO
		add_child(fish)
		test_fish = fish

func _process(delta):
	if not spawned:
		var alge = alge_scene.instantiate()
		used_tile.add_child(alge)
		alge.call("spawn_alge_on", used_tile, 6)
		spawned = true
		spawn_fish(special_fish_scene,"BLUE", 1)
	var mouse_pos = get_global_mouse_position()
	if mouse_pos and test_fish: 
		test_fish.position = get_global_mouse_position()
		test_fish.speed = 0
	
