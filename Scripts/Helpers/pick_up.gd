extends Node3D
class_name PickUp

@export var TAKE_MESSAGE: String = ''
@export var SLOT_DATA: SlotData
@onready var area_3d = $Area3D

var is_active = true
var player: Player

func _ready():
	if GlobalVariables.destroyed_objects.has(to_string()):
		queue_free()
		return

func _on_active_node_action_pressed():
	if GlobalVariables.pick_up_in_area.size() == 0: return
	if GlobalVariables.pick_up_in_area[0] != self: return
	
	if SLOT_DATA is StackableSlotData:
		Events.emit_signal('message_ui', tr(TAKE_MESSAGE) % [SLOT_DATA.AMOUNT])
	else:
		Events.emit_signal('message_ui', tr(TAKE_MESSAGE) % [SLOT_DATA.ITEM_DATA.NAME])

	SLOT_DATA.add_to_inventory()
	GlobalVariables.destroyed_objects.push_back(to_string())
	Events.emit_signal('inventory_update')
	Events.emit_signal('item_pick_up', SLOT_DATA, self)
	queue_free()


func _on_area_3d_body_entered(body):
	if body is Player:
		GlobalVariables.pick_up_in_area.push_back(self)


func _on_area_3d_body_exited(body):
	if body is Player:
		GlobalVariables.pick_up_in_area.erase(self)
