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
#UI
signal player_hp_ui(hp: float)
signal player_reload_data_ui(amount: int, total_amount: int)
#INVENTORY
signal item_pick_up(item_data: ItemData, body: Node3D)
signal inventory_update(item_datas: Array[ItemData])
