class_name Tool
extends Node2D

var flip_counter = 1
var rotation_degree_list = [0,90]

var active = false
var damage = 50
var cooldown = 1
var cooldown_active = false
var interactable_groups = []

var objects_in_range = []
var disabled = false

func _ready():
	$Cooldown.wait_time = cooldown

func update_tool(data):
	cooldown = data["cooldown"]
	$Cooldown.wait_time = cooldown

func activate(input):
	active = input

func use_tool():
	cooldown_active = true
	$Cooldown.start()
	$RotationPoint.rotation = rotation_degree_list[flip_counter]
	flip_counter = (flip_counter + 1) % 2

func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("left_mouse_button"):
		use_tool()

func _on_cooldown_timeout():
	cooldown_active = false
