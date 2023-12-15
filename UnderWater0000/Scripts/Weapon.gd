extends Node2D

@export var max_laser_length = 200
@onready var laser_line = $Sprite/LaserOutput/Line2D
@onready var ray_cast = $Sprite/LaserOutput/RayCast2D
@onready var sprite = $Sprite

var added_laser_start = false
var laser_damage = 20
var laser_cooldown = 0.1
var cooldown_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cooldown.wait_time = laser_cooldown
	ray_cast.target_position = Vector2(max_laser_length,0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var rotation_mod = int (abs(rotation_degrees)) % 360
	sprite.flip_v = (rotation_mod < 270 and rotation_mod > 90) 
	
	look_at(mouse_pos)
	
	if Input.is_action_pressed("left_mouse_button"):
		shoot_laser(to_global(position).distance_to(mouse_pos) - sprite.position.x)
	else:
		laser_line.visible = false

func shoot_laser(length):
	# Draw the line of the laser
	laser_line.visible = true
	var new_position = Vector2(min(max_laser_length,length),0)
	if ray_cast.is_colliding():
		new_position = Vector2(min(max_laser_length,length,ray_cast.get_collision_point().distance_to(to_global(position))- sprite.position.x),0)
	else:
		new_position = new_position
	laser_line.set_point_position(1,new_position / 2)
	laser_line.set_point_position(2,new_position)
	
	# Do damage to tiles
	var collider = ray_cast.get_collider()
	if collider != null and collider.get_groups().has("Tiles") and not cooldown_active:
		cooldown_active = true
		collider.call("mine", laser_damage)
		$Cooldown.start()

func _on_cooldown_timeout():
	cooldown_active = false
