extends Node2D

var rng = RandomNumberGenerator.new()
var noise_one= FastNoiseLite.new()
var noise_seed = 10000
var alge_list = []
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	alge_list = $Rigids.get_children()
	noise_one.seed = noise_seed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	for i in range(alge_list.size()):
#		var noise_value_1 = (noise_one.get_noise_2d(counter + i * 200, 0)) * 10
#		counter += 1
#		alge_list[i].set_linear_velocity(Vector2(noise_value_1, 0))
#		alge_body.linear_velocity = direction
	if counter > 100:
		counter = 0
