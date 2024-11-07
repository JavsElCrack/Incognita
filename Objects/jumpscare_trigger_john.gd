extends Area3D
var playercam
var player
var toggle = false
var checkTransition = false
var timeJ  = 0.05
@export var npc : NPC
@export var bloodsplatterO : BloodSplatter
@export var PlayerStartMarker : Marker3D
@onready var jumpCam = $Camera3D
@onready var marker_3d = $Marker3D
#https://www.youtube.com/watch?v=WCQol0VmA24 blood effects 0:32
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeCamera(body):
		if body.is_in_group("player"):
			GameState.stopJob()
			print("Stopping Job")
			npc.position = marker_3d.position
			playercam = (body as Player).camera
			player = body as Player
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
				npc.textbox.clear_dialogue_box()
				npc.textbox.dialogue_ended.emit()
				GameState.state["flags"]["John"]["cutsceneJohn"] = false

func bloodsplatter():
	npc.visible = false
	npc.position.y -= 2.8
	npc.position.x += 1
	npc.falling()
	npc.textbox.visible = false
	bloodsplatterO.play()

func rotateNPC():
	var initialrot = npc.rotation
	var lookatRot
	npc.look_at(player.position)
	lookatRot = npc.rotation
	npc.rotation = initialrot
	npc.rotation.y = lookatRot.y

func _on_body_entered(body):
	if GameState.state["flags"]["John"]["cutsceneJohn"]:
		changeCamera(body)
		npc.hanging()


func _on_blood_splatter_bloodsplatter_end():
	player = player as Player
	player.toggleBlackScreen()
	changeCamera(player)
	npc.visible = false
	player.transform = PlayerStartMarker.transform
	await get_tree().create_timer(4).timeout
	player.toggleBlackScreen()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameState.mask_dialogue("I still can't believe John is dead")
	
