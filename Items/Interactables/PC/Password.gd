extends SubViewport

@export var password: String = "password"
@export var is_typing: bool = false
@export var audioclips: Array[AudioStreamWAV]
@onready var audiosource = $AudioStreamPlayer
@onready var progress_bar = $CanvasLayer/ProgressBar
@export var pcFlag : String = "default"
var typed_text: String = ""
const MIN_PITCH = 0.2
const MAX_PITCH = 3
signal correctpass(pcFlag)
var keys_pressed: Dictionary = {}

func _ready():
	set_process_input(true)

func _physics_process(delta):
	progress_bar.value = GameState.state["MinigameProgress"]
	$CanvasLayer/PasswordLabel.text = "Password: " + typed_text
	if typed_text == password:
		emit_signal("correctpass",pcFlag)
	if is_typing:
		handle_typing()

func handle_typing():
	if Input.is_action_just_released("ui_text_backspace"):
		if typed_text.length() > 0:
			typed_text = typed_text.left(typed_text.length() - 1)
	elif Input.is_action_just_released("ui_accept"):
		is_typing = false
	for i in range(Key.KEY_0, Key.KEY_9 + 1) + range(Key.KEY_A, Key.KEY_Z + 1):
		if Input.is_key_pressed(i) and not keys_pressed.has(i):
			keys_pressed[i] = true
			var char = OS.get_keycode_string(i).to_lower()
			typed_text += char
			play_keyboard()
	for i in range(Key.KEY_0, Key.KEY_9 + 1) + range(Key.KEY_A, Key.KEY_Z + 1):
		if not Input.is_key_pressed(i):
			keys_pressed.erase(i)
	if Input.is_action_just_released("ui_accept"):
		is_typing = !is_typing

func play_keyboard():
	if audiosource.playing:
		audiosource.stop()
	audiosource.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	var randomIndex = randi_range(0, audioclips.size() - 1)
	audiosource.stream = audioclips[randomIndex]
	audiosource.play()

func clear_text():
	typed_text = ""
