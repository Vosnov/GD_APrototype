extends CharacterBody3D
class_name Enemy

@export var player: Node3D

@onready var state_machine = $StateMachine as StateMachine
@onready var state_label = $StateLabel
@onready var aim_target_component = $AimTargetComponent

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	var current_state_name = state_machine.current_state_name
	state_label.text = str('State: ', EnemyState.StateTypes.keys()[current_state_name])
	state_machine.state_update(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func get_aim_target() -> Vector3:
	return aim_target_component.global_position
