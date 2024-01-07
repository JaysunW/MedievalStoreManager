extends Area2D

var drops_in_range = []
var drops_to_delete = []
var pickup_range = 3.0 * 32

const DROP_SPEED = 10
const MAX_SPEED = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	$RigidCollision.shape.radius = pickup_range
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for drop in drops_in_range:
		if is_instance_valid(drop):
			var new_vec = position - to_local(drop.position)
			drop.linear_velocity += Vector2(new_vec.x, 0).normalized() * DROP_SPEED
			var velocity = drop.linear_velocity
			if velocity.length() >= MAX_SPEED:
				drop.linear_velocity = velocity.normalized() * MAX_SPEED
			if new_vec.length() <= 24:
				drops_to_delete.append(drop)
				drop.destroy_drop()
	for drop in drops_to_delete:
		drops_in_range.erase(drop)
		
func _on_body_entered(body):
	if body.get_groups().has("DROP"):
		drops_in_range.append(body)

func _on_body_exited(body):
	if body.get_groups().has("DROP"):
		drops_in_range.erase(body)
