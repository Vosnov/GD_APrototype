extends Node

#save var
var no_spawn_items: Array[String] = []
var no_spawn_enemys: Array[String] = []
var player_spawn_data: Dictionary = {}
var active_gun: GunData

var player_is_runing = false
var player_is_aim = false
var player_target_is_full = false

func get_data() -> Dictionary:
	return {
		'no_spawn_items': no_spawn_items,
		'no_spawn_enemys': no_spawn_enemys,
		'player_spawn_data': player_spawn_data
	}

func set_data(dict: Dictionary):
	return
	no_spawn_items = dict.no_spawn_items
	no_spawn_enemys = dict.no_spawn_enemys
	player_spawn_data = dict.player_spawn_data
