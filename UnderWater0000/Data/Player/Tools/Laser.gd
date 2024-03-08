extends Tool

@export var max_laser_length = 3
@onready var laser_line = $Sprite/LaserOutput/Line2D
@onready var ray_cast = $Sprite/LaserOutput/RayCast2D
@onready var sprite = $Sprite
@onready var output_light = $Sprite/output_point_light
@onready var contact_light = $Sprite/LaserOutput/contact_point_light

var damage = 0
var added_laser_start = false
var strength = 0
var alternate_modes = null
var overheat = 2
var overheat_active = false

func _ready():
#	damage = 8
#	cooldown = 0.1
	damage = 50
	cooldown = 0.05
	strength = 10
	$Cooldown.wait_time = cooldown
	$Overheat.wait_time = overheat
	ray_cast.target_position = Vector2.ZERO
	laser_line.set_point_position(1,Vector2.ZERO)
	laser_line.set_point_position(2,Vector2.ZERO)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var rotation_mod = int (abs(rotation_degrees)) % 360
	sprite.flip_v = (rotation_mod < 270 and rotation_mod > 90) 
	look_at(mouse_pos)
	if active and Input.is_action_pressed("left_mouse_button"):
		shoot_laser(to_global(position).distance_to(mouse_pos) - sprite.position.x)
	else:
		laser_line.visible = false
		output_light.visible = false
		contact_light.visible = false

func update_tool(data):
	super(data)
	sprite.texture = load(data["sprite_path"])
	damage = data["damage"]
	strength = data["strength"]
	alternate_modes = data["alternate_modes"]
	max_laser_length = data["length"]

func shoot_laser(length):
	# Draw the line of the laser and damage tiles in line
	if not overheat_active:
		output_light.visible = true
		contact_light.visible = true
		var new_position = Vector2(min(max_laser_length * 32,length),0)
		ray_cast.target_position = new_position
		if ray_cast.is_colliding():
			new_position = Vector2(min(max_laser_length * 32,length,ray_cast.get_collision_point().distance_to(to_global(position))- sprite.position.x),0)
		else:
			new_position = new_position
		contact_light.position = new_position
		laser_line.set_point_position(1,new_position / 2)
		laser_line.set_point_position(2,new_position)
		laser_line.visible = true

		# Do damage to tiles
		var collider = ray_cast.get_collider()
		if collider != null and collider.get_groups().has("TILE") and not cooldown_active:
			cooldown_active = true
			if collider.get_hardness() <= strength and collider.destroyable:
				collider.mine( damage)
				$Cooldown.start()
			else:
				laser_line.visible = false
				cooldown_active = false
				overheat_active = true
				$Overheat.start()
	else:
		$Sprite.self_modulate = Color(1,0,0)
		# Add overheat animation/ particles
		pass



func _on_overheat_timeout():
	overheat_active = false
	$Sprite.self_modulate = Color(1,1,1)
	pass # Replace with function body.
