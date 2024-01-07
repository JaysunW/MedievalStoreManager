extends Node2D

@export var alge_scene : PackedScene
@export var tile_scene : PackedScene
var rng = RandomNumberGenerator.new()
var noise_one= FastNoiseLite.new()
var noise_seed = 10000
var alge_list = []
@export var counter = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	#alge_list = $Rigids.get_children()
	noise_one.seed = noise_seed
	spawn_alge(counter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_alge(size):
	var tile = tile_scene.instantiate()
	add_child(tile)
	tile.position = to_global(Vector2(150,250))
	var last_position = Vector2.ZERO
	var previous_alge = null
#	for i in range(size):
#		var current_alge = alge_scene.instantiate()
#		add_child(current_alge)
#		if i != 0:
#			current_alge.position = previous_alge.position + Vector2(0,-16)
#			current_alge.get_node("PinJoint2D").set_node_b(previous_alge.get_path())
#			previous_alge = current_alge
#		else:
#			current_alge.position = tile.position + Vector2(0,-16)
#			current_alge.get_node("PinJoint2D").set_node_b(tile.get_path())
#			previous_alge = current_alge
		
