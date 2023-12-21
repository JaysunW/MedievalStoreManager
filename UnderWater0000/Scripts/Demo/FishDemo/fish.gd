extends RigidBody2D

class_name Fish

@onready var detect_fish_shape = $DetectFish/CollisionShape2D
@onready var sprite = $Sprite

@export var speed = 150
@export var max_speed = 150
@export var min_speed = 75

var rng = RandomNumberGenerator.new()
var type = ""

var counter = 0
var separation_force = 0.11
var alignment_force = 0.1
var cohesion_force = 0.1
var obstacle_avoidance_force = 0.14
var fish_avoidance_force = 0.003

var near_fish = []
var other_fish = []
var obstacles = []
var field_of_vision = -0.2 # Between -1 and 1, 1 directly infront
var vision_radius = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".add_to_group("FISH")
	speed += rng.randi_range(-10,10)
	detect_fish_shape.shape.radius = vision_radius
	linear_velocity = Vector2(max_speed,0).rotated(rotation)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	sprite.look_at(position + linear_velocity)
	sprite.flip_v = abs(sprite.global_rotation) > 1.5

	var cohesion_vector = get_cohesion()
	var separation_vector = get_separation()
	var alignment_vector = get_alignment()
	var obstacle_avoidance_vector = get_obstacle_avoidance()
	var fish_avoidance_vector = get_fish_avoidance()
	
	var velocity_direction =  alignment_vector.normalized() * alignment_force + cohesion_vector.normalized() * cohesion_force
	velocity_direction += fish_avoidance_vector * fish_avoidance_force + linear_velocity.normalized() + separation_vector.normalized() * separation_force
	linear_velocity = (velocity_direction  + obstacle_avoidance_vector.normalized() * obstacle_avoidance_force).normalized() * speed
	special_behaviour()

func special_behaviour():
	pass
	
func set_type(new_type):
	type = new_type

func initialize_fish(input):
	set_type(input)
	self.add_to_group(type)

func set_sprite(new_sprite):
	$Sprite.texture = new_sprite

# Gives the separation vector to fish of same species
func get_separation():
	var separation = Vector2.ZERO
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		connection_vec = connection_vec.normalized() * vision_radius - connection_vec
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
	var cohesion_count = 0
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			cohesion += connection_vec
			cohesion_count += 1
	if cohesion_count > 0:
		cohesion = (cohesion / cohesion_count)
	return cohesion 

# Gives the avoidance vector to obstacle in the way
func get_obstacle_avoidance():
	var obstacle_avoidance = Vector2.ZERO
	for obstacle in obstacles:
		var connection_vec = (obstacle.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			obstacle_avoidance -= connection_vec
	return obstacle_avoidance

# Gives the avoidance vector to other fish of different species
func get_fish_avoidance():
	var avoidance = Vector2.ZERO
	for fish in other_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var avoidance_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			avoidance -= avoidance_ratio * connection_vec
	return avoidance

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and groups.has(type):
		near_fish.append(body)
	elif groups.has("FISH"):
		other_fish.append(body)
	elif groups.has("Obstacle"):
		obstacles.append(body)
		print("Obstacle: " + str(obstacles.size()))

func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type):
		near_fish.erase(body)
	elif groups.has("FISH"):
		other_fish.erase(body)
	elif groups.has("Obstacle"):
		counter += 1
		print("obstacle_delete: " + str(counter))
		obstacles.erase(body)
