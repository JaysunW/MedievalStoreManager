extends Node2D

var id = 0
var drop_type = Enums.DropType.UNKNOWN

func _ready():
	$Lifetime.start()

func update_sprite():
	$Sprite.animation = "A" + str(drop_type)

func _on_lifetime_timeout():
	queue_free()

# Getter and Setter
func get_id():
	return id
func set_id(input):
	id = input
func set_drop_type(input):
	drop_type = input
