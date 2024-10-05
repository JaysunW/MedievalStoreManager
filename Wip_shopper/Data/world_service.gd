extends Node2D

@export var ground_tile_scene : PackedScene
@export var player_scene : PackedScene


var width = 40
var height = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn_ground()
	#spawn_player(Vector2(width/2))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_ground():
	for x in range(width):
		for y in range(height):
			var ground_tile = ground_tile_scene.instantiate()
			if (x % 2 == 0 or y % 2 == 0) and not (x % 2 == 0 and y % 2 == 0):
				ground_tile.highlight(0.15,0.6,0.15)
			else:
				ground_tile.highlight(0.2,0.5,0.2)
			add_child(ground_tile)
			print((x * 8 + y * 8)/8)
#			ground_tile.highlight(/20,0,0)
			ground_tile.set_order((x * 8 + y * 8)/8)
			
			ground_tile.position = Vector2(x * 16 - 16 * y, x * 8 + y * 8)
			
func spawn_player(pos):
	var player = player_scene.instantiate()
	add_child(player)
	player.position = pos
