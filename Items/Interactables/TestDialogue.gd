class_name Talkable extends Interactable



@export var textbox : Textbox
@export var dialogue_json : JSON
@export var parent : Camera3D
@onready var state= {}

func _on_interacted(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	textbox.visible = true
	if body.is_in_group("player"):
		(textbox as Textbox).voiceid = 4
		(textbox.get_child(4) as EzDialogue).start_dialogue(dialogue_json,(body as Player).state)
		(body as Player).lockmovement_and_look($".")
		print("Dialogue Started")
	


