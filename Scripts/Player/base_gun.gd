extends Node3D

@export var MAX_AMOUNT_LOADED = 9
@export var AMMOUNT_LOADED = 9
@export var AMOUNT_TOTAL = 12
@export var SHOT_TIMEOUT = 0.4

@onready var shot_timer = $ShotTimer

var aiming = false

func shot():
	if not shot_timer.is_stopped(): return
	
	if AMMOUNT_LOADED <= 0:
		return
		
	AMMOUNT_LOADED -= 1
	shot_timer.one_shot = true
	shot_timer.start(SHOT_TIMEOUT)
	Events.emit_signal("player_shot")
	print_debug(str("GUN AMOUNT LOADED: ", AMMOUNT_LOADED, " GUN AMOUNT TOTAL: ", AMOUNT_TOTAL))

func reload():
	AMMOUNT_LOADED = min(AMOUNT_TOTAL, MAX_AMOUNT_LOADED)
	AMOUNT_TOTAL -= AMMOUNT_LOADED
	print_debug(str("GUN AMOUNT LOADED: ", AMMOUNT_LOADED, " GUN AMOUNT TOTAL: ", AMOUNT_TOTAL))
	
func _input(event):
	aiming = Input.is_action_pressed("aim")
	if Input.is_action_just_pressed("shot") and aiming:
		shot()
	if Input.is_action_just_pressed("reload"):
		reload()
