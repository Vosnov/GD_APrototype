extends Node

signal player_shot()

signal enemy_target(enemy: Enemy)
signal enemy_target_remove()
signal enemy_take_damage(enemy: Enemy, damage: float)

signal player_hp_ui(hp: float)
signal player_take_damage(damage: float)
