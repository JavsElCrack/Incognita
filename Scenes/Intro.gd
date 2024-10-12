extends Node3D
@onready var introNPC = $Host
@onready var player = $Player

func _ready():
	introNPC.startDialogue(player)


func _on_ez_dialogue_custom_signal_received(value):
	if value == "startGame":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
