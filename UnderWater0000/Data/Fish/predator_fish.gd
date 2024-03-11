class_name PredatorFish
extends Fish
 
@onready var out_of_range_timer = $OutOfRangeTimer
@onready var attack_timer = $AttackTimer
@onready var attack_cooldown_timer = $AttackCooldownTimer
# Stats
var damage = 10
var attack_speed_up = 10
var cooldown_speed_down = 10

var target = null
var out_of_range_time = 5
var attack_time = 3 
var attack_cooldown_time = 2 

var chase_factor = 0.5

func _ready():
	out_of_range_timer.wait_time = out_of_range_time
	attack_timer.wait_time = attack_time
	attack_cooldown_timer.wait_time = attack_cooldown_time
	self.add_to_group("PREDATOR")
	super()

func _physics_process(_delta):
	super(_delta)
	match current_state:
		Enums.FishState.SWIMMING:
			speed = normal_speed
			attack_timer.stop()
			attack_cooldown_timer.stop()
			target_in_vision()
		Enums.FishState.CHASING:
			if target == null:
				current_state = Enums.FishState.SWIMMING
				return
			var connection_vec = target.position - position
			if connection_vec.length() > vision_radius:
				if out_of_range_timer.is_stopped():
					out_of_range_timer.start()
			else:
				if not out_of_range_timer.is_stopped():
					out_of_range_timer.stop()
				if attack_cooldown_timer.is_stopped():
					if attack_timer.is_stopped():
						attack_timer.start()
						speed = normal_speed + attack_speed_up
					elif connection_vec.length() < 10:
						attack_fish()
						attack_timer.stop()
						attack_cooldown_timer.start()
						speed = normal_speed - cooldown_speed_down
			linear_velocity = (linear_velocity.normalized() + connection_vec.normalized() * chase_factor).normalized() * speed
	special_behaviour()
	
func target_in_vision():
	var nearest_fish = null
	var min_dst = vision_radius
	for fish in other_fish:
		var groups = fish.get_groups() 
		if not groups.has("PREDATOR"):
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
	target.call("take_damage", damage)
		
func get_fish_avoidance():
	return Vector2.ZERO

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and groups.has(type):
		near_fish.append(body)
	elif groups.has("OBSTACLE"):
		obstacles.append(body)
	elif groups.has("FISH") and current_state == Enums.FishState.SWIMMING:
		other_fish.append(body)
	
func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type):
		near_fish.erase(body)
	elif groups.has("OBSTACLE"):
		obstacles.erase(body)
	elif groups.has("FISH"):
		other_fish.erase(body)

func _on_out_of_range_timeout():
	set_state(Enums.FishState.SWIMMING)
	target = null

func _on_attack_timer_timeout():
	attack_cooldown_timer.start()
	speed = normal_speed - cooldown_speed_down
	pass # Replace with function body.

func _on_attack_cooldown_timer_timeout():
	speed = normal_speed
	pass
