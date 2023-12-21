extends Fish

@onready var line = $LineToNearFish
@onready var line2 = $CenterOfFish
@onready var line3 = $Separation
@onready var line4 = $Aligment
@onready var line5 = $Obstacle
@onready var line6 = $Direction

func special_behaviour():
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
	if cohesion_vector: line_around_point(line2,to_local(position + cohesion_vector))
	var separation_vector = get_separation()

	line3.add_point(to_local(position))
	line3.add_point(to_local(position + separation_vector.normalized() * 32 * 1.2))
	var alignment_vector = get_alignment()
	line4.add_point(to_local(position))
	line4.add_point(to_local(position + alignment_vector.normalized() * 32 * 1.4))
	var obstacle_avoidance_vector = get_obstacle_avoidance()
	for obstacle in obstacles:
		var connection_vec = (obstacle.position) - (position) 
		var dot_product = linear_velocity.normalized().dot(connection_vec.normalized())
		if dot_product >= field_of_vision:
			line5.add_point(to_local(position + connection_vec))
			line5.add_point(to_local(position))
	
	line5.add_point(to_local(position + obstacle_avoidance_vector.normalized() * 32 * 1.6))
	line6.add_point(to_local(position))
	line6.add_point(to_local(position + linear_velocity / speed * 32 * 1.8))

func line_around_point(line_node,pos): 
	var size = 6
	line_node.add_point(pos + Vector2(size,0))
	line_node.add_point(pos + Vector2(0,size))
	line_node.add_point(pos + Vector2(-size,0))
	line_node.add_point(pos + Vector2(0,-size))
	line_node.add_point(pos + Vector2(size,0))

func _on_detect_fish_body_entered(body):
	var groups = body.get_groups() 
	if body != $"." and groups.has(type):
		near_fish.append(body)
	elif groups.has("FISH"):
		other_fish.append(body)
	elif groups.has("Obstacle"):
		obstacles.append(body)

func _on_detect_fish_body_exited(body):
	var groups = body.get_groups() 
	if groups.has(type):
		near_fish.erase(body)
	elif groups.has("FISH"):
		other_fish.erase(body)
	elif groups.has("Obstacle"):
		obstacles.erase(body)
