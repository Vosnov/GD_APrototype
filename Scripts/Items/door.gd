extends StaticBody3D
class_name Door

enum AcceptState {
	ACCEPT,
	NEED_ACCEPT,
	CLOSE,
	NONE
}

@export var NAME = ''
@export var ACCEPT_STATE = AcceptState.ACCEPT
@export_file("*.tscn") var NEXT_SCENE
@export var NEED_KEY_DATA: ItemData
@export var CLOSE_MESSAGE: String
@export var NEED_ACCEPT_MESSAGE: String
@export var OPENED_MESSAGE: String

@export var CLOSING_AUDIO: AudioStream
@export var OPEN_AUDIO: AudioStream
@export var BROKEN_AUDIO: AudioStream
@export var KEY_OPEN_DOOR: AudioStream

@onready var spawn_point = $SpawnPoint as Node3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

var is_accepted = false
var door_opened_message = ""

func _ready():
	if NAME == '':
		printerr('Please add door NAME')
	
	if GlobalVariables.door_prev_scene == NEXT_SCENE:
		audio_stream_player_3d.stream = CLOSING_AUDIO
		audio_stream_player_3d.play()
	
	if NEED_KEY_DATA:
		door_opened_message = tr(OPENED_MESSAGE) % [NEED_KEY_DATA.NAME]

func has_key():
	var items = Inventory.SLOTS.map(func(slot: SlotData): return slot.ITEM_DATA)
	return items.has(NEED_KEY_DATA)

func _on_door_active_node_action_pressed():
	if ACCEPT_STATE == AcceptState.CLOSE:
		play_audio(BROKEN_AUDIO)
		
		Events.emit_signal('message_ui', CLOSE_MESSAGE)
		touch_door()
		return
		
	if ACCEPT_STATE == AcceptState.NEED_ACCEPT and !is_accepted:
		if has_key():
			play_audio(KEY_OPEN_DOOR)
			
			Events.emit_signal('inventory_remove_item', NEED_KEY_DATA)
			Events.emit_signal('message_ui', door_opened_message)
			is_accepted = true
			touch_door()
			return
		else:
			play_audio(BROKEN_AUDIO)
			
			Events.emit_signal('message_ui', NEED_ACCEPT_MESSAGE)
			touch_door()
			return
	
	play_audio(OPEN_AUDIO)
	GlobalVariables.door_prev_scene = owner.scene_file_path
	touch_door()
	SceneTransition.change_scene(NEXT_SCENE)

func play_audio(stream: AudioStream):
	if audio_stream_player_3d.playing: return
	audio_stream_player_3d.stream = stream
	audio_stream_player_3d.play()

func touch_door():
	var touch_door_name = str(owner.scene_file_path, '_', NAME)
	GlobalVariables.touched_doors[touch_door_name] = ACCEPT_STATE
