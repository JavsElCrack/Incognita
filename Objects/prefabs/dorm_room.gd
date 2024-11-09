extends Node3D
@onready var door = $Door

func toggleDoor():
	door.toggleDoor()
