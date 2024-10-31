extends Node

@export var obstacle_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func new_game():
	$Player.start($StartPosition.position)
	
func _on_obstacle_timer_timeout():
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	
	obstacle_spawn_location.progress_ratio = randf()
	
	#Spawn Obstacle
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)

	#Set Position
	obstacle.position = obstacle_spawn_location.position
