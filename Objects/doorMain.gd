extends Node3D
@onready var door = $door

func toggleDoor():
	door.toggleDoor()
