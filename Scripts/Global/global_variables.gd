extends Node

#save var
var no_spawn_items: Array[String] = []
var no_spawn_enemys: Array[String] = []
var player_spawn_data: Dictionary = {}
var player_ammo_load: Dictionary = {}
var active_gun: GunData

var menu_ui_is_open = false
var player_is_runing = false
var player_is_aim = false
var player_target_is_full = false
var save_data: Dictionary = {}

func get_data() -> Dictionary:
	return {
		'no_spawn_items': no_spawn_items,
		'no_spawn_enemys': no_spawn_enemys,
		'player_spawn_data': player_spawn_data,
		'player_ammo_load': player_ammo_load
	}

func set_data(dict: Dictionary):
	no_spawn_items = dict.no_spawn_items
	no_spawn_enemys = dict.no_spawn_enemys
	player_spawn_data = dict.player_spawn_data
	player_ammo_load = dict.player_ammo_load

func get_save_data() -> Dictionary:
	save_data.date = get_current_date()
	return save_data

func get_current_date() -> String:
	var date = Time.get_date_dict_from_system()
	var time = Time.get_time_dict_from_system()
	return "%02d.%02d.%02d %02d:%02d" % [date.day, date.month, date.year, time.hour, time.minute]
