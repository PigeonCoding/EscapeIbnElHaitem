extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position.x = get_viewport().get_visible_rect().size.x / 2
	global_position.y = get_viewport().get_visible_rect().size.y / 2
	
	pass
