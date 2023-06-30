extends Node
class_name StateMachine

@export var AGENT: Enemy

var current_state: EnemyState
var current_state_name: EnemyState.StateTypes
var state_list: Array[Node] = []

func _ready():
	current_state_name = AGENT.get_init_state()
	
	state_list = get_children()
	for child in state_list:
		if child.STATE_TYPE == AGENT.get_init_state():
			current_state = child
			current_state.enter()

func get_state(state_name: EnemyState.StateTypes):
	for state in state_list:
		if state.STATE_TYPE == state_name:
			return state
	return null

func state_update(delta: float):
	if current_state == null:
		return
	
	var new_state_name = current_state.update(delta)
	
	if new_state_name != current_state_name:
		var new_state = get_state(new_state_name)
		if new_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
			current_state_name = new_state_name
