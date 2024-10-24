extends Node
var player
func _ready():
	player = get_tree().get_nodes_in_group("player")
	print(player)
var state := {
	"null" : null,
	"enableMinigame": false,
	"MinigameProgress": 50,
	"TestPickup": 0,
	"TestPickupFlag": true, 
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
		},
		"Claudia": {
			"firsttime": true,
		},
		"John": {
			"readNeilEmail": false
		},
		"Kenneth": {
			"jumpscare": false
		},
		"firsttimedialog" : true
	}
}

var dialgpos = Vector2(1262, 747.8)
func mask_dialogue(text:String):
	player = get_tree().get_nodes_in_group("player")
	(player[0] as Player).mask_dialogue(text)
