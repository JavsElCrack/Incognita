extends Node
var player
func _ready():
	player = get_tree().get_nodes_in_group("player")
	print(player)
var state := {
	"null" : null,
	"enableMinigame": false,
	"MinigameProgress": 30,
	"TestPickup": 0,
	"TestPickupFlag": true, 
	"minigameFirstTime" : true,
	"doJob" : true,
	"settings": {
			"sensitivity" : 0.003,
			"ps1filter" : false,
		},
	"flags": {
		"Neil": {
			"firsttime": true,
			"gift": false
		},
		"Door": {
			"locked": false,
			"kennethdoor": false,
			"playerDoor": false,
			"laylaDoor": false,
			"smokeLounge": false,
			"gauchoDoor" :  false,
			"claudiaDoor" :  true,
			"neilDoor" :  true,
			"johnDoor" : true,
			"general" : true,
		},
		"ComputerRead": {
			"default": false,
			"Neil": false,
			"Gaucho":false,
		},
		"Claudia": {
			"firsttime": true,
		},
		"John": {
			"readNeilEmail": false,
			"cutsceneJohn": false,
		},
		"Kenneth": {
			"jumpscare": false
		},
		"Layla": {
			"jumpscare": false
		},
		"Guacho": {
			"computer": false
		},
		"firsttimedialog" : true
	}
}


var dialgpos = Vector2(1262, 747.8)
func mask_dialogue(text:String):
	player = get_tree().get_nodes_in_group("player")
	(player[0] as Player).mask_dialogue(text)


func pagerMessage(message : String):
	player = get_tree().get_nodes_in_group("player")
	(player[0] as Player).pagerMessage(message)


func stopJob():
	GameState.state["doJob"] = false
	GameState.state["MinigameProgress"] = 100
