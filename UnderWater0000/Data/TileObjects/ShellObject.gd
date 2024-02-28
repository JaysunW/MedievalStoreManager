extends ObjectOnTile

const Pearl_sprite = preload("res://Assets/Drop/Pearl.png")

func _ready():
	super()
	drop_type = Enums.DropType.SHELL

func update_sprite():
	match type:
		0:
			animation = "Basic" 
		1:
			animation = "Roll"
		2:
			animation = "Clean"
		3:
			animation = "Open"
		Enums.TileType.UNKNOWN:
			print("Something went wrong with the coral sprite update.")
		_:
			animation = "Basic"
	sprite.animation = animation
	frame = rng.randi_range(0, sprite.sprite_frames.get_frame_count(animation)) # Could be done with noise to make it not random
	sprite.frame = frame

func destroyed():
	dropped.emit(to_global(position), border_idx, drop_type, Pearl_sprite)
	queue_free()
