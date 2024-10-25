extends Node2D

@onready var spawn_position = $SpawnPosition
@export var package : PackedScene
@export var tile_map : TileMap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("x"):
		var spawned_package = package.instantiate()
		spawned_package.position = spawn_position.global_position
		var rng = RandomNumberGenerator.new()
		spawned_package.data = Data.item_data[rng.randi_range(0,3)].duplicate()
		tile_map.add_child(spawned_package)
