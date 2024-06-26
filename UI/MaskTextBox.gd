extends MarginContainer
@onready var label = $MarginContainer/Label
@onready var timer = $Control/LetterDisplayTimer
@onready var audiosource = $Control/AudioStreamPlayer
@onready var pitch = $Control/AudioStreamPlayer.pitch_scale
@onready var buttonparent = $VBoxContainer/HBoxContainer
@onready var initialsize = size

@export var audioclips : Array[AudioStreamWAV]


var StopAudioSource = true
const MAX_WIDTH = 700
const MIN_PITCH = 0.2
const MAX_PITCH = 3
var text = ""
var voiceid = 0
var islastdialogue = false
var letter_index = 0
var choice_buttons: Array[Button] = []

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var count = 0
var initialsizetext = Vector2(0,0)
signal finished_displaying()
signal dialogue_started()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	display_text("Use WASD to move
				 and E to interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_text(text_to_display: String):
	visible = true
	count += 1
	letter_index = 0
	text = text_to_display
	label.text = ""
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
	_display_letter()


func _display_letter():
	if letter_index < text.length():
		label.text += text[letter_index]
		play_sound_hash(text[letter_index], audioclips)
		letter_index += 1
		if letter_index >= text.length():
			finished_displaying.emit()
			if islastdialogue == true:
				finish_dialogue()
			return
		match text[letter_index]:
			"!", ".", ",", "?":
				timer.start(punctuation_time)
			" ":
				timer.start(space_time)
			_:
				timer.start(letter_time)
	else:
		finished_displaying.emit()


func play_sound_hash(letter: String, audioclips):
	if audiosource.playing == true and StopAudioSource == true:
		audiosource.stop()
	pitch = randf_range(MIN_PITCH, MAX_PITCH)
	var hashs = letter.sha256_buffer()
	var index = hashs[0] % audioclips.size()
	var max_Pitchint: int = MAX_PITCH * 100
	var min_Pitchint: int = MIN_PITCH * 100

	var pitchRange = max_Pitchint - min_Pitchint
	pitch = ((hashs[0] % pitchRange) + MIN_PITCH) / 100
	audiosource.stream = audioclips[index]
	audiosource.play()

func finish_dialogue():
	pass

func clear_dialogue_box():
	label.text = ""
	size = initialsize
	visible = false
func _on_letter_display_timer_timeout():
	_display_letter()


func _on_finished_displaying():
	await get_tree().create_timer(2.0).timeout
	clear_dialogue_box()
