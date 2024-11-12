extends Node3D
var player
var flag1 = true
var flag2 = true
var playerInArea = false
var gamePlayTimer = 7
@export_category("Dialogues")
@export var kennethdDiag : JSON
@export var kennethdDiagGaucho : JSON
@export var newJohnDiag : JSON
@export var newLaylaDiag : JSON
@export var newGauchoDiag : JSON
@export var finalLaylaDiag : JSON
@export var endScene : PackedScene
@export_category("NPCs")
@export var gaucho : NPC
@export var layla : NPC
@export var smokeNpc : NPC
@onready var gunshot = $johnjumpscareTrigger2/Gunshot
@onready var hallwaymarker = $TeleportHallway/hallwaymarker
@onready var jumpscare_trigger = $jumpscareTrigger
@onready var kenneth: NPC = $Kenneth 
@onready var hide_john_marker = $HideJohnMarker
@onready var john = $John
@onready var johnJupscare = $johnjumpscareTrigger2
@onready var room = $Environment/Room
@onready var layla_final_marker = $LaylaFinalMarker
var lockedDoors  := {
			"locked": false,
			"kennethdoor": false,
			"playerDoor": true,
			"laylaDoor": false,
			"smokeLounge": true,
			"gauchoDoor" :  false,
			"claudiaDoor" :  false,
			"neilDoor" :  false,
			"johnDoor" : false,
			"general" : false,
		}

func _ready():
	#TODO comment line
#	debugMode()
	player = get_tree().get_first_node_in_group("player")
	maskDialogueInitial()


func _on_ez_dialogue_custom_signal_received(value):
	if has_method(value):
		call(value)



func _on_pass_word_viewport_correctpass(pcFlag):
	GameState.state["flags"]["ComputerRead"][pcFlag] = true


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if flag1:
			GameState.mask_dialogue("This is your computer
			 the password is: password")
			flag1 = false
		playerInArea = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		flag2 = true


func _on_teleport_hallway_body_entered(body):
	if body.is_in_group("player"):
		body.global_position.z = hallwaymarker.global_position.z
func removeGift():
	GameState.mask_dialogue("What a problematic couple")
	GameState.state["flags"]["Neil"]["gift"] = false
func neilFirstTime():
	GameState.state["flags"]["Neil"]["firsttime"] = false
func kennethStop():
	jumpscare_trigger.changeCamera(player)
	GameState.mask_dialogue("I wonder where John is")
func triggerJumpscare():
	GameState.state["flags"]["Kenneth"]["jumpscare"] = true
func changeKennethVoice():
	kenneth.updateVoiceID(9)
func moveKenneth():
	kenneth.dialogue_json = kennethdDiag
	kenneth.global_position.z += 1
	john.global_position =hide_john_marker.global_position
	john.dialogue_json = newJohnDiag
	kenneth.rotation.y = 90
	GameState.state["flags"]["Kenneth"]["jumpscare"] = false
	GameState.state["flags"]["Door"]["laylaDoor"] = true
func maskDialogueInitial():
	GameState.mask_dialogue("Use WASD to move
		 and E to interact")
	GameState.mask_dialogue("This is your computer
	The password is password
	DON'T FORGET TO WORK")
	#await get_tree().create_timer(gamePlayTimer).timeout
	#TODO comment out the line below
#	GameState.state["flags"]["Door"]["playerDoor"] = true
func openSmokeLounge():
	GameState.mask_dialogue("Maybe we shouldn't go there")
	GameState.state["flags"]["Door"]["smokeLounge"] = true


func triggerJohnEnd():
	kenneth.global_position = hide_john_marker.global_position
	smokeNpc.global_position = hide_john_marker.global_position
	gaucho.global_position = hide_john_marker.global_position
	layla.global_position = layla_final_marker.global_position
	layla.dialogue_json = finalLaylaDiag
	room.toggleDoor()
	lockDoors()
	gunshot.play()
	await get_tree().create_timer(0.05).timeout
	player.toggleBlackScreen()
	await get_tree().create_timer(1).timeout
	player.toggleBlackScreen()
	johnJupscare.bloodsplatter()
	await get_tree().create_timer(4).timeout
	player = player as Player
	player.tween_effect_strength(4)



func johnWindowMask1():
	GameState.mask_dialogue("I don't think talking to him is a good idea")

func johnWindowMask2():
	GameState.mask_dialogue("That's not a smart move.")


func unlockGauchoDoor():
	GameState.state["flags"]["Door"]["gauchoDoor"] = true

func triggerJohnCutscene():
	GameState.state["flags"]["John"]["cutsceneJohn"] = true


func lockDoors():
	GameState.state["flags"]["Door"] =  lockedDoors


func endGauchoIntro():
	kenneth.dialogue_json = kennethdDiagGaucho
	gaucho.dialogue_json = newGauchoDiag
	layla.dialogue_json = newLaylaDiag

func endActOne():
	get_tree().change_scene_to_packed(endScene)

func debugMode():
	GameState.state["flags"]["Door"]["playerDoor"] = true
	GameState.state["MinigameProgress"] = 100
	GameState.state["doJob"] = false



func _on_johnjumpscare_trigger_2_stop_music():
	$Music.stop()
