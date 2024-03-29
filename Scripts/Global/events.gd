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
signal player_take_health(hp_recover: int)
signal player_dead()
#UI
signal player_hp_ui(hp: float)
signal player_reload_data_ui(amount: int, total_amount: int)
signal message_ui(message: String)
signal message_close_ui(message: String)
signal map_set_move_mode(value: bool)
signal map_floor_empty(floor: int)
#INVENTORY
signal item_pick_up(slot_data: SlotData, body: Node3D)
signal inventory_remove_item(item: ItemData)
signal inventory_update()
#Settings
signal settings_change()
