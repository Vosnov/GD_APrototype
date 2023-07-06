extends Node3D

@export var MUZZLE_FLASH: PackedScene
@export var MAX_AMOUNT_LOADED = 9
@export var AMOUNT_LOADED = 9
@export var SHOT_TIMEOUT = 0.4
@export var RELOAD_TIMEOUT = 1.0

@onready var shot_timer = $ShotTimer
@onready var reload_timer = $ReloadTimer
@onready var muzzle_pos = $MuzzlePos

var aiming = false
var is_runing = false
var is_reloading = false
var amount_total = 0

func _ready():
	if GlobalVariables.gun_amount_loaded >= 0:
		AMOUNT_LOADED = GlobalVariables.gun_amount_loaded
	_on_inventory_update(Inventory.SLOTS)
	Events.connect('inventory_update', _on_inventory_update)
	Events.emit_signal("player_reload_data_ui", AMOUNT_LOADED, amount_total)

func shot():
	if not shot_timer.is_stopped(): return
	
	if AMOUNT_LOADED <= 0: return
		
	AMOUNT_LOADED -= 1
	GlobalVariables.gun_amount_loaded = AMOUNT_LOADED
	shot_timer.one_shot = true
	shot_timer.start(SHOT_TIMEOUT)
	Events.emit_signal("player_shot")
	Events.emit_signal("player_reload_data_ui", AMOUNT_LOADED, amount_total)
	
	var muzzle = MUZZLE_FLASH.instantiate()
	muzzle_pos.add_child(muzzle)

func reload():
	if amount_total == 0: return
	if AMOUNT_LOADED == MAX_AMOUNT_LOADED: return
	
	var need_amount = MAX_AMOUNT_LOADED - AMOUNT_LOADED
	AMOUNT_LOADED += min(need_amount, amount_total)
	amount_total -= AMOUNT_LOADED
	is_reloading = true
	reload_timer.one_shot = true
	reload_timer.start(RELOAD_TIMEOUT)
	Events.emit_signal("player_reload", need_amount)
	Events.emit_signal("player_reload_data_ui", AMOUNT_LOADED, amount_total)

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

func _on_inventory_update(slots: Array[SlotData]):
	amount_total = 0
	for slot in slots:
		if slot.ITEM_DATA is AmmoData:
			amount_total += slot.AMOUNT
	Events.emit_signal("player_reload_data_ui", AMOUNT_LOADED, amount_total)
