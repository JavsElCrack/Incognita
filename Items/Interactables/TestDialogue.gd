extends Interactable



@export var textboxscene = preload("res://UI/text_box.tscn")

func _on_interacted(body):
	var textbox = textboxscene.instantiate()
	textbox.display_text("Coito")
