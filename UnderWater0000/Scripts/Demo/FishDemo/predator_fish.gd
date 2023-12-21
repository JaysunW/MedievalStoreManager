extends Fish

class_name PredatorFish

func _ready():
	$".".add_to_group("PREDATOR")
	super()

func get_fish_avoidance():
	return Vector2.ZERO

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and not groups.has(type) and groups.has("FISH"):
		near_fish.append(body)
	elif groups.has("Obstacle"):
		obstacles.append(body)
	
func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if not groups.has(type) and groups.has("FISH"):
		near_fish.erase(body)
	elif groups.has("Obstacle"):
		obstacles.erase(body)
