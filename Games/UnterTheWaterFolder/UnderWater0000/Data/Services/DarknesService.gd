extends CanvasModulate

@onready var player = $"../Character"
@onready var world_height = $"../GridService".get_size().y

@export var light_offset = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	light_offset = world_height/light_offset
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var value = max(0,(world_height - light_offset - (player.position.y/32))/(world_height - light_offset))
	color = Color(value,value,value,1)
