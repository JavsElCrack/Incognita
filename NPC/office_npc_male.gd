extends NPC

@export var sitting : bool = false

func _ready():
	connect("interacted",_on_interacted)
	nav_agent.connect("target_reached",_on_navigation_agent_3d_target_reached)
	if sitting:
		$AnimationTree.set("parameters/conditions/sit",true)

