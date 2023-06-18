extends Node3D

@export var MAX_AMOUNT_LOADED = 9
@export var AMMOUNT_LOADED = 9
@export var AMOUNT_TOTAL = 120
@export var SHOT_TIMEOUT = 0.4
@export var RELOAD_TIMEOUT = 1.0

@onready var shot_timer = $ShotTimer
@onready var reload_timer = $ReloadTimer

var aiming = false
var is_runing = false
var is_reloading = false

func _ready():
	Events.emit_signal("player_reload_data_ui", AMMOUNT_LOADED, AMOUNT_TOTAL)

func shot():
	if not shot_timer.is_stopped(): return
	
	if AMMOUNT_LOADED <= 0: return
		
	AMMOUNT_LOADED -= 1
	shot_timer.one_shot = true
	shot_timer.start(SHOT_TIMEOUT)
	Events.emit_signal("player_shot")
	Events.emit_signal("player_reload_data_ui", AMMOUNT_LOADED, AMOUNT_TOTAL)

func reload():
	if AMOUNT_TOTAL == 0: return
	if AMMOUNT_LOADED == MAX_AMOUNT_LOADED: return
	
	AMMOUNT_LOADED = min(AMOUNT_TOTAL, MAX_AMOUNT_LOADED)
	AMOUNT_TOTAL -= AMMOUNT_LOADED
	is_reloading = true
	reload_timer.one_shot = true
	reload_timer.start(RELOAD_TIMEOUT)
	Events.emit_signal("player_reload")
	Events.emit_signal("player_reload_data_ui", AMMOUNT_LOADED, AMOUNT_TOTAL)
	
func _input(_event):
	aiming = Input.is_action_pressed("aim")
	is_runing = Input.is_action_pressed("sprint")
	
	if is_reloading: return
	
	if Input.is_action_just_pressed("shot") and aiming:
		shot()
	if Input.is_action_just_pressed("reload") and not is_runing:
		reload()


func _on_reload_timer_timeout():
	is_reloading = false
