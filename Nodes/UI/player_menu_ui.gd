extends TabContainer
class_name PlayerMenuUI

@export var TAB_TITLES: Array[String] = []

func _ready():
	if TAB_TITLES.size() != get_tab_count():
		printerr('Check TAB_TITLES')
		return
		
	for index in get_tab_count():
		set_tab_title(index, TAB_TITLES[index])
	
	GlobalVariables.menu_ui_is_open = true
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false
	GlobalVariables.menu_ui_is_open = false

func _input(_event):
	if Input.is_action_just_pressed('next_tab'):
		current_tab = clamp(current_tab + 1, 0, get_tab_count() - 1)
	if Input.is_action_just_pressed('prev_tab'):
		current_tab = clamp(current_tab - 1, 0, get_tab_count() - 1)
	
	if Input.is_action_just_pressed('ui_cancel'):
		queue_free()
	if Input.is_action_just_pressed('ui_menu'):
		current_tab = 0
	if Input.is_action_just_pressed('map'):
		current_tab = 1
