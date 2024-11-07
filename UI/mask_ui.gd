extends Node3D
var playqueue = []
var isPlaying =  false
var remove
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func mask_dialogue(text: String):
	if isPlaying:
		if playqueue.has(text):
			pass
		else:
			playqueue.append(text)
	else:
		$Control/TextureRect/TextBox.display_text(text)


func _on_text_box_dialogue_ended():
	isPlaying = false
	if remove != null:
		playqueue.erase(remove)
	if playqueue.size() > 0:
		mask_dialogue(playqueue[0])
		remove = playqueue[0]

func _on_text_box_dialogue_started():
	isPlaying = true
	
