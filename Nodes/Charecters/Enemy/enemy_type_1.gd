extends CharacterBody3D
class_name Enemy

@export var player: Node3D

@onready var state_machine = $StateMachine as StateMachine
@onready var nav_agent = $NavigationAgent3D as NavigationAgent3D
@onready var animation_tree = $AnimationTree
@onready var state_label = $StateLabel

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	var current_state_name = state_machine.current_state_name
	state_label.text = str('State: ', EnemyState.StateTypes.keys()[current_state_name])
	state_machine.state_update(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
