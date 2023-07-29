extends StaticBody3D
class_name Door

@export var NAME = ''
@export var ACCEPT_STATE = DoorActiveNode.AcceptState.ACCEPT
@export_file("*.tscn") var NEXT_SCENE
@export var NEED_KEY_DATA: ItemData
@export var CLOSE_MESSAGE: String
@export var NEED_ACCEPT_MESSAGE: String
@export var OPENED_MESSAGE: String

@export var CLOSING_AUDIO: AudioStream
@export var OPEN_AUDIO: AudioStream
@export var BROKEN_AUDIO: AudioStream
@export var KEY_OPEN_DOOR: AudioStream

@onready var active_node = $DoorActiveNode as DoorActiveNode
@onready var spawn_point = $SpawnPoint
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
	active_node.ACCEPT_STATE = ACCEPT_STATE

func has_key():
	var items = Inventory.SLOTS.map(func(slot: SlotData): return slot.ITEM_DATA)
	return items.has(NEED_KEY_DATA)

func _on_door_active_node_action_pressed():
	if ACCEPT_STATE == DoorActiveNode.AcceptState.CLOSE:
		play_audio(BROKEN_AUDIO)
		
		Events.emit_signal('message_ui', CLOSE_MESSAGE)
		touch_door()
		return
		
	if ACCEPT_STATE == DoorActiveNode.AcceptState.NEED_ACCEPT and !is_accepted:
		if has_key():
			play_audio(KEY_OPEN_DOOR)
			
			active_node.change_sprite(DoorActiveNode.AcceptState.ACCEPT)
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
	GlobalVariables.player_spawn_data[owner.scene_file_path] = spawn_point.global_transform
	GlobalVariables.door_prev_scene = owner.scene_file_path
	touch_door()
	SceneTransition.change_scene(NEXT_SCENE)

func play_audio(stream: AudioStream):
	if audio_stream_player_3d.playing: return
	audio_stream_player_3d.stream = stream
	audio_stream_player_3d.play()

func touch_door():
	var name = str(owner.scene_file_path, '_', NAME)
	GlobalVariables.touched_doors[name] = ACCEPT_STATE
