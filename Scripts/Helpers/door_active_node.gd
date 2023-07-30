extends ActiveNode
class_name DoorActiveNode

enum AcceptState {
	ACCEPT,
	NEED_ACCEPT,
	CLOSE,
	NONE
}

@export var ACCEPT_SPRITE: PackedScene
@export var NEED_ACCEPT_SPRITE: PackedScene
@export var CLOSE_SPRITE: PackedScene

@export var ACCEPT_STATE = AcceptState.ACCEPT:
	set(value):
		SPRITE = get_sprite_by_state(value)
		ACCEPT_STATE = value

func get_sprite_by_state(state: AcceptState):
	if state == AcceptState.ACCEPT:
		return ACCEPT_SPRITE
	if state == AcceptState.NEED_ACCEPT:
		return NEED_ACCEPT_SPRITE
	if state == AcceptState.CLOSE:
		return CLOSE_SPRITE

func change_sprite(state: AcceptState):
	ACCEPT_STATE = state
	if sprite != null: 
		sprite.queue_free()
		sprite = get_sprite_by_state(state).instantiate()
		add_child(sprite)
