class_name Fish
extends RigidBody2D

@onready var detect_fish_shape = $DetectFish/CollisionShape2D
@onready var sprite = $Sprite
@onready var stress_timer = $StressTimer

# Stats
var max_health = 100
var health = 0

var size = 0
var catch_chance = 10
var normal_speed = 100
var speed = normal_speed
var stress_speed_up = 20
var stress_time = 3

var rng = RandomNumberGenerator.new()
var type = ""

var counter = 0
var separation_force = 0.1
var alignment_force = 0.1
var cohesion_force = 0.1
var obstacle_avoidance_force = 0.14
var fish_avoidance_force = 0.1
var predator_avoidance_force = 0.14

var current_state = Enums.FishState.SWIMMING

var near_fish = []
var other_fish = []
var predator_fish = []
var obstacles = []
var field_of_vision = -0.2 # Between -1 and 1, 1 directly infront
var vision_radius = 64

signal caught(type)
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	self.add_to_group("FISH")
	stress_timer.wait_time = stress_time
	speed += rng.randi_range(-10,10)
	#detect_fish_shape.shape.radius = vision_radius
	linear_velocity = Vector2(normal_speed,0).rotated(rotation)
	pass

func _physics_process(_delta):
	sprite.look_at(position + linear_velocity)
	sprite.flip_v = abs(sprite.global_rotation) > 1.5

	var cohesion_vector = calc_cohesion()
	var separation_vector = calc_separation()
	var alignment_vector = calc_alignment()
	var obstacle_avoidance_vector = calc_obstacle_avoidance()
	var fish_avoidance_vector = calc_fish_avoidance()
	var predator_avoidance_vector = calc_predator_avoidance()
	
	var velocity_direction =  alignment_vector.normalized() * alignment_force + cohesion_vector.normalized() * cohesion_force
	velocity_direction += fish_avoidance_vector.normalized() * fish_avoidance_force + linear_velocity.normalized() + separation_vector.normalized() * separation_force
	velocity_direction = (velocity_direction  + obstacle_avoidance_vector.normalized() * obstacle_avoidance_force).normalized()
	if position.y < (grid_service.water_edge_y + 2) * 32:
		linear_velocity = (velocity_direction + predator_avoidance_vector.normalized() * obstacle_avoidance_force + Vector2.DOWN).normalized() * speed
	else:
		linear_velocity = (velocity_direction + predator_avoidance_vector.normalized() * obstacle_avoidance_force).normalized() * speed
	special_behaviour()
	
func special_behaviour():
	pass

func take_damage(damage):
	health -= damage
	print("Health: " , health)
	print(": fish.gd")
	if health < 0:
		print("Dead")
	stress_timer.start()
	speed += stress_speed_up

func try_catch_fish(value):
	print("Value in: ",value)
	var rand_int = randi_range(0,99)
	var gate = round(catch_chance + value * 1 - health/max_health)
	print("Rand_int: " , rand_int)
	print("Gate: ", gate)
	if rand_int < gate:
		caught.emit(type)
	else:
		$EscapedTimer.start()
		$Sprite.self_modulate = Color(0,0,1)

func get_caught_signal():
	return caught

func initialize_fish(input):
	set_type(input)
	self.add_to_group(type)
	
func set_type(new_type):
	type = new_type

func set_sprite(new_sprite):
	$Sprite.texture = new_sprite
	
func set_state(new_state):
	current_state = new_state
	
func set_size(_size):
	size = _size
	match size:
		0:
			return
		1:
			var sprite = $CollisionShape2D
			sprite.scale = Vector2(0.5,0.5)
			var collision_shape = $CollisionShape2D
			collision_shape.radius = 16
			collision_shape.height = 85
		2: 
			print("Problem : fish.gd")
		_:
			print("Problem : fish.gd")
			
# Gives the separation vector to fish of same species
func calc_separation():
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
func calc_alignment():
	var alignment = Vector2.ZERO
	for fish in near_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var alignment_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			alignment += alignment_ratio * fish.linear_velocity.normalized()
	return alignment

# Gives the cohesion vector to fish of same species
func calc_cohesion():
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
func calc_obstacle_avoidance():
	var obstacle_avoidance = Vector2.ZERO
	for obstacle in obstacles:
		var connection_vec = (obstacle.position) - (position) 
		if obstacle.get_groups().has("ALGE"):
			connection_vec = obstacle.position + obstacle.get_parent().get_parent().position - (position)
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			obstacle_avoidance -= connection_vec
	return obstacle_avoidance

# Gives the avoidance vector to other fish of different species
func calc_fish_avoidance():
	var avoidance = Vector2.ZERO
	for fish in other_fish:
		var connection_vec = (fish.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			var avoidance_ratio = clamp((vision_radius - connection_vec.length()) / vision_radius,0,1)
			avoidance -= avoidance_ratio * connection_vec
	return avoidance

func calc_predator_avoidance():
	var avoidance_vec = Vector2.ZERO
	for predator in predator_fish:
		var connection_vec = (predator.position) - (position) 
		avoidance_vec -= connection_vec
	return avoidance_vec

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and groups.has(type):
		near_fish.append(body)
	elif groups.has("PREDATOR"):
		predator_fish.append(body)
	elif groups.has("FISH"):
		other_fish.append(body)
	elif groups.has("OBSTACLE"):
		obstacles.append(body)

func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type):
		near_fish.erase(body)
	elif groups.has("PREDATOR"):
		predator_fish.erase(body)
	elif groups.has("FISH"):
		other_fish.erase(body)
	elif groups.has("OBSTACLE"):
		obstacles.erase(body)

func _on_stress_timer_timeout():
	speed = normal_speed
	pass # Replace with function body.

func _on_escaped_timer_timeout():
	$Sprite.self_modulate = Color(1,1,1)
