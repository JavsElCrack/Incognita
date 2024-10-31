extends SubViewport
@onready var animation_player_2 = $"Node3D/Gold Apollo AR924/AnimationPlayer2"
@onready var label = $"Node3D/Gold Apollo AR924/MeshInstance3D/SubViewport/CanvasLayer/ColorRect/Label"


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player_2.play("slideout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func slidein():
	animation_player_2.play("slidein")

func slideout():
	animation_player_2.play("slideout")

func updatePagerText(nText : String):
	label.text = nText
