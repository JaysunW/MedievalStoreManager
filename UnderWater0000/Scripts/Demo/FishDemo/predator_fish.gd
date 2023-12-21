extends Fish

class_name Predator_fish

func get_fish_avoidance():
	return Vector2.ZERO

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and (groups.has(type) or groups.has("FISH")):
		near_fish.append(body)
	elif groups.has("Obstacle"):
		obstacles.append(body)
	
func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type) or groups.has("FISH"):
		obstacles.erase(body)
	elif groups.has("Obstacle"):
		other_fish.erase(body)
