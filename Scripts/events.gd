extends Node

#ENEMY
signal enemy_target(enemy: Enemy)
signal enemy_target_remove()
signal enemy_take_damage(enemy: Enemy, damage: float)
#PLAYER
signal player_shot()
signal player_take_damage(damage: float)
#UI
signal player_hp_ui(hp: float)

