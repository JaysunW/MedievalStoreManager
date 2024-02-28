class_name ObjectOnTile
extends Node2D

var sprite = null
var animation = null
var frame = null

var rng = RandomNumberGenerator.new()
var max_health = 100
var health = max_health
var border_idx = 0

var animation_frames = 0

var type = null
var drop_type = Enums.DropType.UNKNOWN

signal dropped(pos, border_idx, drop_type, sprite)

func _ready():
	sprite = $Sprite

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		destroyed()
		
func update_sprite():
	pass
	
func get_drop_signal():
	return dropped
	
func get_type():
	return type
	
func set_border_idx(value):
	border_idx = value

func destroyed():
	dropped.emit(to_global(position), border_idx, drop_type, $Sprite.sprite_frames.get_frame_texture($Sprite.animation, $Sprite.frame))
	queue_free()
