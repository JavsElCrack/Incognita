extends Interactable



@export var textbox : MarginContainer
@export var dialogue_json : JSON
@export var parent : Camera3D
@onready var state= {}

func _on_interacted(_body):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	(textbox.get_child(4) as EzDialogue).start_dialogue(dialogue_json,state)
	
