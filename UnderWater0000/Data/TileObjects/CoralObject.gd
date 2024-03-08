extends ObjectOnTile

var not_enough_sprites = false

func _ready():
	super()
	drop_type = Enums.DropType.CORAL

func update_sprite():
	print(border_idx)
	match int(border_idx):
		0:
			animation = "Basic"
		1:
			animation = "Bowl"
		2:
			animation = "Brain"
		3:
			animation = "Rock"
		4:
			animation = "Tree"
		Enums.TileType.UNKNOWN:
			print("Something went wrong with the coral sprite update.")
		_:
			animation = "Brain"
	print("An: ", animation)
	frame = rng.randi_range(0, sprite.sprite_frames.get_frame_count(animation))
	sprite.animation = animation
	sprite.frame = frame
