extends CharacterBody2D

@export var free_cam_active = false
const SPEED = 150.0
const SLIP = 20.0
const MAX_Y_VELOCITY = 200
const JUMP_VELOCITY = -250

signal free_cam

@onready var sprite = $Sprite

var on_land = true
var gravity_clamp = 0.2

func _ready():
	if free_cam_active:
		$Camera2D.enabled = false
	else:
		free_cam.emit()
	position = Vector2(0,-32 )
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	var direction = Vector2(Input.get_axis("left", "right"),0) # Get the input direction and handle.
	
	if on_land: # On land physics 
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			velocity.y += gravity * _delta * gravity_clamp
	else: # Under water physics
		direction.y = Input.get_axis("up", "down")
		if not is_on_floor() and velocity.y < MAX_Y_VELOCITY: # Add the gravity till termal velocity is reached.
			velocity.y += gravity * _delta * gravity_clamp 
			
	if direction.x:
		velocity.x = direction.x * SPEED
		sprite.frame = (direction.x + 1)/2
	else:
		velocity.x = move_toward(velocity.x, 0, SLIP)
	if direction.y < 0:
		velocity.y = direction.y * SPEED * 0.5
	elif direction.y > 0:
		velocity.y = max(direction.y * SPEED * 0.5, velocity.y)
	move_and_slide()

func _on_air_area_body_entered(body):
	if body.get_groups().has("Player"):
		velocity.y = JUMP_VELOCITY * 0.5
		on_land = true;
		gravity_clamp = 1
		$PointLight2D.visible = false

func _on_water_area_body_entered(body):
	if body.get_groups().has("Player"):
		on_land = false;
		velocity.y = velocity.y * 0.2
		gravity_clamp = 0.2
		# Turn flashlight on when at certain depth
		#$PointLight2D.visible = true
