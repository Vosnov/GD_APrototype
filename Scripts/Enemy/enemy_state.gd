extends Node
class_name EnemyState

@export var AGENT: Enemy
@export var STATE_TYPE: StateTypes

enum StateTypes {
	NONE,
	FOLLOW,
	WAIT,
	ATTACK,
	PATROL,
	STAY
}

func enter():
	pass

func exit():
	pass

func update(_delta: float) -> StateTypes:
	return StateTypes.NONE
