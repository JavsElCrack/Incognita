class_name NPC extends Interactable



@export var textbox : Textbox
@export var dialogue_json : JSON
@export var voiceID : int
@export var lookatPos : Node3D
@onready var state= {}
func _ready():
	connect("interacted",_on_interacted)

func _on_interacted(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	textbox.visible = true
	if body.is_in_group("player"):
		(textbox as Textbox).voiceid = voiceID
		(textbox.get_child(4) as EzDialogue).start_dialogue(dialogue_json,GameState.state)
		(body as Player).lockmovement_and_look(lookatPos)
		var initialrot = self.rotation
		var lookatRot
		self.look_at(body.position)
		self.rotate_object_local(Vector3(0,1,0), 3.14)
		lookatRot = self.rotation
		self.rotation = initialrot
		self.rotation.y = lookatRot.y
		print("Dialogue Started")
	
