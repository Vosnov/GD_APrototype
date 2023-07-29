extends Node

#Saved variables
var no_spawn_items: Array[String] = []
var no_spawn_enemys: Array[String] = []
var player_spawn_data: Dictionary = {}
var player_ammo_load: Dictionary = {}
var active_gun_index = -1
var save_data: Dictionary = {}
var touched_doors: Dictionary = {}
var visited_rooms: Array[String] = []

var menu_ui_is_open = false
var player_is_runing = false
var player_is_aim = false
var player_target_is_full = false
var should_spawn_on_player_transform = false
var door_prev_scene = '' # Need for plaing close door stream
var pick_up_in_area: Array[Node] = []
#Settings
var setting_mouse = 1.0

const save_count = 4

func get_data() -> Dictionary:
	return {
		'no_spawn_items': no_spawn_items,
		'no_spawn_enemys': no_spawn_enemys,
		'player_spawn_data': player_spawn_data,
		'player_ammo_load': player_ammo_load,
		'active_gun_index': active_gun_index,
		'save_data': save_data,
	}

func set_data(dict: Dictionary):
	no_spawn_items = dict.no_spawn_items
	no_spawn_enemys = dict.no_spawn_enemys
	player_spawn_data = dict.player_spawn_data
	player_ammo_load = dict.player_ammo_load
	active_gun_index = dict.active_gun_index
	save_data = dict.save_data

func get_date_format(date_string: String) -> String:
	var date = Time.get_datetime_dict_from_datetime_string(date_string, false)
	return "%02d.%02d.%02d %02d:%02d" % [date.day, date.month, date.year, date.hour, date.minute]
