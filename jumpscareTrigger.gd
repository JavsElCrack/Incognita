extends Area3D
var playercam
var player
var toggle = false
var checkTransition = false
var timeJ  = 0.05
@export var npc : NPC
@onready var jumpCam = $Camera3D
@onready var marker_3d = $Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeCamera(body):
		if body.is_in_group("player"):
			GameState.state["doJob"] =  false
			npc.global_transform = marker_3d.global_transform
			playercam = (body as Player).camera
			player = body
			if toggle == false:
				print("Player to PC")
				CameraTransition.transition_camera(playercam,jumpCam,timeJ)
				(body as Player).raycast.showPrompt = false
				(body as Player).lockmovement = true
				(body as Player).crosshair.visible = false
				toggle = true
				npc.startDialogue(player)
			else:	
				print("PC to Player")
				CameraTransition.transition_camera(jumpCam,playercam,timeJ)
				(body as Player).raycast.showPrompt = true
				checkTransition = true
				(body as Player).crosshair.visible = true
				toggle = false
				npc.textbox.visible = false
				npc.textbox.islastdialogue = false
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				npc.textbox.clear_dialogue_box()
				npc.textbox.dialogue_ended.emit()
				GameState.state["flags"]["Kenneth"]["jumpscare"] = false
				GameState.state["doJob"] =  true

func rotateNPC():
	var initialrot = npc.rotation
	var lookatRot
	npc.look_at(player.position)
	lookatRot = npc.rotation
	npc.rotation = initialrot
	npc.rotation.y = lookatRot.y

func _on_body_entered(body):
	if GameState.state["flags"]["Kenneth"]["jumpscare"]:
		changeCamera(body)
