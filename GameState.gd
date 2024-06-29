extends Node
var player
func _ready():
	player = get_tree().get_nodes_in_group("player")
var state :={
	"TestPickup": 0,
	"TestPickupFlag": true 
	}

func mask_dialogue(text:String):
	(player[0] as Player).mask_dialogue(text)
