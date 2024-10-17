extends Node
var player
func _ready():
	player = get_tree().get_nodes_in_group("player")
	print(player)
var state := {
	"null" : null,
	"enableMinigame": false,
	"MinigameProgress": 0,
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
			"laylaDoor": false,
		},
		"Claudia": {
			"firsttime": true,
		},
		"John": {
			"readNeilEmail": false
		},
		"Kenneth": {
			"jumpscare": true
		},
		"firsttimedialog" : true
	}
}

var dialgpos : Vector2
func mask_dialogue(text:String):
	player = get_tree().get_nodes_in_group("player")
	(player[0] as Player).mask_dialogue(text)
