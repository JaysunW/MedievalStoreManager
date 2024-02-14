extends Node2D

@export var alge_scene : PackedScene
@onready var used_tile = $"../Tile4"

var spawned = false

func _process(delta):
	if not spawned:
		var alge = alge_scene.instantiate()
		print("First: " + str(alge.position) + " tile_pos: " + str(used_tile.position))
		used_tile.add_child(alge)
		alge.call("spawn_alge_on", used_tile)
		print("second: " + str(alge.position) + " tile_pos: " + str(used_tile.position))
		spawned = true
