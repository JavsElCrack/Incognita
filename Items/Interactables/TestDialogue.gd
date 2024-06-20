class_name Talkable extends Interactable



@export var textbox : Textbox
@export var dialogue_json : JSON
@export var voiceID : int
@onready var state= {}

func _on_interacted(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	textbox.visible = true
	if body.is_in_group("player"):
		(textbox as Textbox).voiceid = voiceID
		(textbox.get_child(4) as EzDialogue).start_dialogue(dialogue_json,GameState.state)
		(body as Player).lockmovement_and_look($".")
		print("Dialogue Started")
	


