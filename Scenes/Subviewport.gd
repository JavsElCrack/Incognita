extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewport.size =   get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
