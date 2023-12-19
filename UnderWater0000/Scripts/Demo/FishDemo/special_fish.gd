extends RigidBody2D

@onready var line = $LineToNearFish
@onready var line2 = $CenterOfFish
@onready var line3 = $Avoidance
@onready var line4 = $Aligment
@onready var line5 = $Obstacle
@onready var line6 = $Direction
@onready var detect_fish_shape = $DetectFish/CollisionShape2D
@onready var sprite = $Sprite

@export var speed = 150
@export var max_speed = 150
@export var min_speed = 75

var type = "NORMAL"

var separation_force = 0.14
var alignment_force = 0.15
var cohesion_force = 0.1
var obstacle_avoidance_force = 0.2
var fish_avoidance_force = 0.15

var near_fish = []
var other_fish = []
var obstacles = []
var field_of_vision = -0.2 # Between -1 and 1, 1 directly infront
var vision_radius = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	detect_fish_shape.shape.radius = vision_radius
	linear_velocity = Vector2(max_speed,0).rotated(rotation)
	pass # Replace with function body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	sprite.look_at(position + linear_velocity)
	sprite.flip_v = abs(sprite.global_rotation) > 1.5
	line.clear_points()
	line2.clear_points()
	line3.clear_points()
	line4.clear_points()
	line5.clear_points()
	line6.clear_points()
	
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			line.add_point(to_local(position))
			line.add_point(to_local(fish.position))
	
	var cohesion_vector = get_cohesion()
	if cohesion_vector: line_around_point(to_local(position + cohesion_vector))
	var separation_vector = get_separation()
	line3.add_point(to_local(position))
	line3.add_point(to_local(position + separation_vector))
	var alignment_vector = get_alignment()
	line4.add_point(to_local(position))
	line4.add_point(to_local(position + alignment_vector))
	var obstacle_avoidance_vector = get_obstacle_avoidance()
	line5.add_point(to_local(position))
	line5.add_point(to_local(position + obstacle_avoidance_vector))
	var fish_avoidance_vector = get_fish_avoidance()
	
	
	var velocity_direction =  alignment_vector.normalized() * alignment_force + cohesion_vector.normalized() * cohesion_force
	velocity_direction += fish_avoidance_vector.normalized() * fish_avoidance_force + linear_velocity.normalized() + separation_vector.normalized() * separation_force
	linear_velocity = (velocity_direction  + obstacle_avoidance_vector.normalized() * obstacle_avoidance_force).normalized() * speed
	line6.add_point(to_local(position))
	line6.add_point(to_local(position + linear_velocity / speed * 32 * 2))
	
# Gives the separation vector to fish of same species
func get_separation():
	var separation = Vector2.ZERO
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var separation_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			separation -= separation_ratio * connection_vec
	return separation

# Gives the alignment vector to fish of same species
func get_alignment():
	var alignment = Vector2.ZERO
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var alignment_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			alignment += alignment_ratio * fish.linear_velocity.normalized()
	return alignment

# Gives the cohesion vector to fish of same species
func get_cohesion():
	var cohesion = Vector2.ZERO
	var counter = 0
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			cohesion += connection_vec
			counter += 1
	if counter > 0:
		cohesion = (cohesion / counter)
	return cohesion 

# Gives the avoidance vector to obstacle in the way
func get_obstacle_avoidance():
	var obstacle_avoidance = Vector2.ZERO
	for obstacle in obstacles:
		var connection_vec = (obstacle.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			obstacle_avoidance -= connection_vec
			line5.add_point(to_local(position))
			line5.add_point(to_local(obstacle.position))
	return obstacle_avoidance

# Gives the avoidance vector to other fish of different species
func get_fish_avoidance():
	var separation = Vector2.ZERO
	for fish in other_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var separation_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			separation -= separation_ratio * connection_vec
	return separation

func line_around_point(pos):
	var size = 6
	line2.add_point(pos + Vector2(size,0))
	line2.add_point(pos + Vector2(0,size))
	line2.add_point(pos + Vector2(-size,0))
	line2.add_point(pos + Vector2(0,-size))
	line2.add_point(pos + Vector2(size,0))

func _on_detect_fish_area_entered(area):
	if area != $Area2D and area.get_groups().has(type):
		near_fish.append(area.get_parent())
	elif area.get_groups().has("FISH"):
		other_fish.append(area.get_parent())
		
func _on_detect_fish_area_exited(area):
	if area.get_groups().has(type):
		near_fish.erase(area.get_parent())
	elif area.get_groups().has("FISH"):
		other_fish.append(area.get_parent())

func _on_detect_fish_body_entered(body):
	if body.get_groups().has("Obstacle"):
		obstacles.append(body)

func _on_detect_fish_body_exited(body):
	if body.get_groups().has("Obstacle"):
		obstacles.erase(body)
