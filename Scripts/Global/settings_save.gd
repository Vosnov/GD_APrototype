extends Node

var path = 'user://settings.cfg'
var config = ConfigFile.new()
var default_config = ConfigFile.new()

func _ready():
	set_default_config()
	load_settings()

func get_config() -> ConfigFile:
	return config

func load_settings():
	var err = config.load(path)
	
	if err != OK: 
		config.parse(default_config.encode_to_text())
	load_all_settings()

func set_default_config():
	#Audio
	for bus_index in AudioServer.bus_count:
		default_config.set_value('Audio', str(bus_index), AudioServer.get_bus_volume_db(bus_index))
	#Graphics
	default_config.set_value('Graphics', 'fullscreen', DisplayServer.window_get_mode())
	default_config.set_value('Graphics', 'resolution', DisplayServer.window_get_size())
	#Control
	default_config.set_value('Control', 'mouse', 1.0)
	#Game
	default_config.set_value('Game', 'lang', OS.get_locale_language())

func save_settings_by_default():
	config.parse(default_config.encode_to_text())
	
	config.save(path)
	load_all_settings()

func save_settings():
	config.save(path)
	load_all_settings()

func load_all_settings():
	load_audio_settings()
	load_graphics_settings()
	load_control_settings()
	load_game_settings()

func load_audio_settings():
	for bus_index in AudioServer.bus_count:
		AudioServer.set_bus_volume_db(bus_index, config.get_value('Audio', str(bus_index)))

func load_graphics_settings():
	DisplayServer.window_set_mode(config.get_value('Graphics', 'fullscreen'))
	
	get_tree().root.content_scale_size = config.get_value('Graphics', 'resolution')
	DisplayServer.window_set_size(config.get_value('Graphics', 'resolution'))

func load_control_settings():
	GlobalVariables.setting_mouse = config.get_value('Control', 'mouse')

func load_game_settings():
	TranslationServer.set_locale(config.get_value('Game', 'lang'))
