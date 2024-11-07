extends Node3D
var player
var flag1 = true
var flag2 = true
var playerInArea = false
var gamePlayTimer = 7
@export var kennethdDiag : JSON
@export var newJohnDiag : JSON
@onready var gunshot = $johnjumpscareTrigger2/Gunshot
@onready var hallwaymarker = $TeleportHallway/hallwaymarker
@onready var jumpscare_trigger = $jumpscareTrigger
@onready var kenneth: NPC = $Kenneth 
@onready var hide_john_marker = $HideJohnMarker
@onready var john = $John
@onready var johnJupscare = $johnjumpscareTrigger2


func _ready():
	player = get_tree().get_first_node_in_group("player")
	maskDialogueInitial()
#	await get_tree().create_timer(5).timeout
#	GameState.pagerMessage("BOSS: Get back to work!")
#


func _on_ez_dialogue_custom_signal_received(value):
	if has_method(value):
		call(value)



func _on_pass_word_viewport_correctpass():
	GameState.state["flags"]["John"]["readNeilEmail"] = true


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
	GameState.state["flags"]["Neil"]["gift"] = false
func neilFirstTime():
	GameState.state["flags"]["Neil"]["firsttime"] = false
func kennethStop():
	jumpscare_trigger.changeCamera(player)
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
	await get_tree().create_timer(0).timeout
	GameState.state["flags"]["Door"]["playerDoor"] = true
func openSmokeLounge():
	GameState.state["flags"]["Door"]["smokeLounge"] = true


func triggerJohnEnd():
	gunshot.play()
	await get_tree().create_timer(0.05).timeout
	player.toggleBlackScreen()
	await get_tree().create_timer(1).timeout
	player.toggleBlackScreen()
	johnJupscare.bloodsplatter()
