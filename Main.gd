extends Node

@export var obstacle : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func new_game():
	$Player.start($StartPosition.position)
	
func _on_mob_timer_timeout():
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	
	obstacle_spawn_location.progress_ratio = randf()
	
	#Spawn Obstacle
#	var mob = mob_scene.instantiate()
#	add_child(mob)

	#Set Position
#	mob.position = mob_spawn_location.position

	#Set speed
#	var velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
#	mob.linear_velocity = velocity.rotated(direction)
