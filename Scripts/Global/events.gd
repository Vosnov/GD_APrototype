extends Node

#ENEMY
signal enemy_target(enemy: Enemy)
signal enemy_target_remove()
signal enemy_take_damage(enemy: Enemy, damage: float)
signal enemy_die(enemy: Enemy)
#PLAYER
signal player_shot()
signal player_reload(amount_drop: int)
signal player_take_damage(damage: float)
signal player_dead()
#UI
signal player_hp_ui(hp: float)
signal player_reload_data_ui(amount: int, total_amount: int)
signal message_ui(message: String, _message_owner: Node)
signal message_close_ui(_message_owner: Node)
#INVENTORY
signal item_pick_up(slot_data: SlotData, body: Node3D)
signal inventory_update(slot_datas: Array[SlotData])
