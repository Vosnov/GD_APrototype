extends CharacterBody3D
class_name Enemy

signal take_damage()

@export var HP = 3.0
@export var DYING_ANIM_NAME = 'Dying'
@export var INIT_STATE = EnemyState.StateTypes.PATROL

@onready var state_machine = $StateMachine as StateMachine
@onready var state_label = $StateLabel
@onready var aim_target_component = $AimTargetComponent
@onready var animation_tree = $AnimationTree
@onready var stering_behavior = $SteeringBehaviorComponent

var player: Node3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var enemy_is_target = false
var is_dead = false

func _ready():
	if GlobalVariables.no_spawn_enemys.has(get_path().get_concatenated_names()):
		queue_free()
	Events.connect('enemy_take_damage', _on_take_damage)

func _physics_process(delta):
	var current_state_name = state_machine.current_state_name
	state_label.text = str('State: ', EnemyState.StateTypes.keys()[current_state_name])
	
	if is_dead: return
	
	state_machine.state_update(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func get_aim_target() -> Vector3:
	if aim_target_component == null:
		return global_position
	return aim_target_component.global_position

func die():
	is_dead = true
	animation_tree.set("parameters/main_trans/transition_request", 'dying')
	aim_target_component.queue_free()
	stering_behavior.queue_free()
	Events.emit_signal('enemy_die', self)
	GlobalVariables.no_spawn_enemys.push_back(get_path().get_concatenated_names())

func get_init_state():
	return INIT_STATE

func _on_take_damage(enemy: Enemy, damage: float):
	if enemy == self:
		HP -= damage
		take_damage.emit()
		if HP <= 0: die()

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == DYING_ANIM_NAME:
		process_mode = Node.PROCESS_MODE_DISABLED

func _on_player_finding_area_body_entered(body):
	player = body
