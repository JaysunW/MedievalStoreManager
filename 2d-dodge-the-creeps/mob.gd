extends RigidBody2D

@export var min_speed = 150
@export var max_speed = 250

func _ready():
	$AnimatedSprite2D.play()
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.animation = type

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
