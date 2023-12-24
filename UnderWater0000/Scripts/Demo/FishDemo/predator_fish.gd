class_name PredatorFish
extends Fish
 
@onready var out_of_range_timer = $OutOfRangeTimer
@onready var attack_timer = $AttackTimer
@onready var attack_cooldown_timer = $AttackCooldownTimer

var target = null
var damage = 10
var out_of_range_time = 5

var chase_factor = 0.5

func _ready():
	normal_speed = 90
	out_of_range_timer.wait_time = out_of_range_time
	$".".add_to_group("PREDATOR")
	super()

func _physics_process(_delta):
	super(_delta)
	if current_state == Enums.FishState.SWIMMING:
		speed = normal_speed
		attack_cooldown_timer.stop()
		attack_timer.stop()
		target_in_vision()
	elif current_state == Enums.FishState.CHASING:
		var connection_vec = target.position - position
		if connection_vec.length() > vision_radius:
			if out_of_range_timer.is_stopped():
				out_of_range_timer.start()
		else:
			if not out_of_range_timer.is_stopped():
				out_of_range_timer.stop()
			if attack_timer.is_stopped() and attack_cooldown_timer.is_stopped():
				
				attack_timer.start()
				speed += rng.randi_range(30,40)
				print("Attacking: ", speed)
		linear_velocity = (linear_velocity.normalized() + connection_vec.normalized() * chase_factor).normalized() * speed
	special_behaviour()
	
func target_in_vision():
	var nearest_fish = null
	var min_dst = vision_radius
	for fish in other_fish:
		var groups = fish.get_groups() 
		if groups.has("FISH") and not groups.has(type):
			var connection_vec = (fish.position) - (position) 
			var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
			if dot_product >= field_of_vision:
				var connection_len = connection_vec.length()
				if  connection_len< min_dst:
					min_dst = connection_len
					nearest_fish = fish
	if nearest_fish != null:
		target = nearest_fish
		set_state(Enums.FishState.CHASING)
		
func attack_fish():
	target.get_node("Fish").call("take_damage", 10)
		
func get_fish_avoidance():
	return Vector2.ZERO

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and groups.has(type):
		near_fish.append(body)
	elif groups.has("Obstacle"):
		obstacles.append(body)
	elif groups.has("FISH") and current_state == Enums.FishState.SWIMMING:
		other_fish.append(body)
	
func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type):
		near_fish.erase(body)
	elif groups.has("Obstacle"):
		obstacles.erase(body)
	elif groups.has("FISH"):
		other_fish.erase(body)


func _on_out_of_range_timeout():
	print("stopped attack")
	set_state(Enums.FishState.SWIMMING)
	target = null


func _on_attack_timer_timeout():
	print("Stop attacking: " + str(speed) + " norm: " + str(normal_speed))
	speed = normal_speed
	attack_cooldown_timer.start()
	pass # Replace with function body.


func _on_attack_cooldown_timer_timeout():
	pass
