extends RigidBody2D

@onready var detect_fish_shape = $DetectFish/CollisionShape2D

@export var speed = 150

var separation_force = 0.15
var alignment_force = 0.1
var cohesion_force = 0.1
var avoid_obstacle_force = 0.2

var near_fish = []
var obstacles = []
var field_of_vision = -0.2 # Between -1 and 1, 1 directly infront
var vision_radius = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	detect_fish_shape.shape.radius = vision_radius
	linear_velocity = Vector2(speed,0).rotated(rotation)
	pass # Replace with function body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Sprite.look_at(position + linear_velocity)
	var counter = 0
	var center_of_flog = Vector2.ZERO
	var avoidance = Vector2.ZERO
	var alignment = Vector2.ZERO
	var obstacle_avoidance = Vector2.ZERO
	
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			center_of_flog += connection_vec
			counter += 1
			var alignment_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			alignment += alignment_ratio * fish.linear_velocity.normalized()
			var separation_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			avoidance -= separation_ratio * connection_vec
	if counter > 0:
		center_of_flog = (center_of_flog / counter)
	for obstacle in obstacles:
		var connection_vec = (obstacle.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var separation_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			obstacle_avoidance -= separation_ratio * connection_vec
	var direction = linear_velocity.normalized() + separation_force * avoidance.normalized() + cohesion_force * center_of_flog.normalized()
	linear_velocity = (direction + alignment_force * alignment.normalized() + avoid_obstacle_force * obstacle_avoidance.normalized()).normalized() * speed

func _on_detect_fish_area_entered(area):
	if area.get_groups().has("Fish"):
		if area != $Area2D:
			near_fish.append(area.get_parent())
		
func _on_detect_fish_area_exited(area):
	if area.get_groups().has("Fish"):
		near_fish.erase(area.get_parent())


func _on_detect_fish_body_entered(body):
	
	if body.get_groups().has("Obstacle"):
			obstacles.append(body)

func _on_detect_fish_body_exited(body):
	if body.get_groups().has("Obstacle"):
			obstacles.erase(body)
