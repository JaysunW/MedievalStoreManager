extends Node2D

@export var max_laser_length = 200
@onready var laser_line = $Sprite/LaserOutput/Line2D
@onready var ray_cast = $Sprite/LaserOutput/RayCast2D
@onready var sprite = $Sprite

var added_laser_start = false
var laser_strength = 10
var laser_damage = 20
var laser_cooldown = 0.001
var laser_overheat = 2
var cooldown_active = false
var overheat_active = false

func _ready():
	$Cooldown.wait_time = laser_cooldown
	$Overheat.wait_time = laser_overheat
	ray_cast.target_position = Vector2.ZERO
	laser_line.set_point_position(1,Vector2.ZERO)
	laser_line.set_point_position(2,Vector2.ZERO)

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
	# Draw the line of the laser and damage tiles in line
	if not overheat_active:
		var new_position = Vector2(min(max_laser_length,length),0)
		ray_cast.target_position = new_position
		if ray_cast.is_colliding():
			new_position = Vector2(min(max_laser_length,length,ray_cast.get_collision_point().distance_to(to_global(position))- sprite.position.x),0)
		else:
			new_position = new_position

		laser_line.set_point_position(1,new_position / 2)
		laser_line.set_point_position(2,new_position)
		laser_line.visible = true

		# Do damage to tiles
		var collider = ray_cast.get_collider()
		if collider != null and collider.get_groups().has("Tiles") and not cooldown_active:
			cooldown_active = true
			if collider.call("get_hardness") <= laser_strength:
				collider.call("mine", laser_damage)
				$Cooldown.start()
			else:
				laser_line.visible = false
				cooldown_active = false
				overheat_active = true
				$Overheat.start()
	else:
		# Add overheat animation/ particles
		pass
			

# Cooldown timer
func _on_cooldown_timeout():
	cooldown_active = false


func _on_overheat_timeout():
	overheat_active = false
	pass # Replace with function body.
