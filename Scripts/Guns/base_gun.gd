extends Node3D
class_name BaseGun

@export var FULL_DAMAGE = 1.0
@export var DAMAGE = 1.0
@export var AMMO_LOADED = 9
@export var MAX_AMMO_LOADED = 9
@export var SHOT_TIMEOUT = 1.0
@export var RELOAD_TIMEOUT = 1.0
@export var DROP_AMMO = 1

@export var ITEM_GUN_DATA: ItemGunData
@export var MUZZLE_FLASH: PackedScene

@onready var muzzle_pos = $MuzzlePos

var is_shotting = false
var is_reloading = false
var amount_total = 0
var target: Enemy

func _ready():
	if GlobalVariables.player_ammo_load.has(ITEM_GUN_DATA.NAME):
		AMMO_LOADED = GlobalVariables.player_ammo_load[ITEM_GUN_DATA.NAME]
	
	_on_inventory_update()
	Events.emit_signal("player_reload_data_ui", AMMO_LOADED, amount_total)
	Events.connect('inventory_update', _on_inventory_update)
	Events.connect("enemy_target", _on_aim_component_enemy_target)
	Events.connect("enemy_target_remove", _on_aim_component_enemy_target_remove)

func shot():
	if is_shotting: return
	if AMMO_LOADED <= 0: return
	if AMMO_LOADED < DROP_AMMO: return
	
	is_shotting = true
	AMMO_LOADED -= DROP_AMMO
	
	Events.emit_signal("player_shot")
	Events.emit_signal("player_reload_data_ui", AMMO_LOADED, amount_total)
	GlobalVariables.player_ammo_load[ITEM_GUN_DATA.NAME] = AMMO_LOADED
	
	var muzzle = MUZZLE_FLASH.instantiate()
	muzzle_pos.add_child(muzzle)
	
	_override_shot()
	
	await get_tree().create_timer(SHOT_TIMEOUT).timeout
	is_shotting = false
	
func _override_shot():
	pass

func reload():
	if amount_total == 0: return
	if AMMO_LOADED == MAX_AMMO_LOADED: return
	
	is_reloading = true
	
	var need_amount = MAX_AMMO_LOADED - AMMO_LOADED
	AMMO_LOADED = AMMO_LOADED + min(need_amount, amount_total)
	amount_total -= AMMO_LOADED
	Events.emit_signal("player_reload", need_amount)
	Events.emit_signal("player_reload_data_ui", AMMO_LOADED, amount_total)
	GlobalVariables.player_ammo_load[ITEM_GUN_DATA.NAME] = AMMO_LOADED
	
	await get_tree().create_timer(RELOAD_TIMEOUT).timeout
	is_reloading = false

func _input(_event):
	if is_reloading: return
	
	if Input.is_action_just_pressed("shot") and GlobalVariables.player_is_aim:
		shot()
	if Input.is_action_just_pressed("reload") and not GlobalVariables.player_is_runing:
		reload()

func _on_inventory_update():
	amount_total = 0
	for slot in Inventory.SLOTS:
		if slot.ITEM_DATA is AmmoData:
			amount_total += slot.AMOUNT
	Events.emit_signal("player_reload_data_ui", AMMO_LOADED, amount_total)

func _on_aim_component_enemy_target(body: Enemy):
	target = body

func _on_aim_component_enemy_target_remove():
	target = null
