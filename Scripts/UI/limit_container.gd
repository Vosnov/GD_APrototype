@tool
extends Container
class_name LimitContainer

@export var COUNT = 5:
	set(value):
		COUNT = value
		queue_sort()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var item_size = floor(size.x / COUNT)
		var index = 0
		
		for c in get_children():
			var pos = Vector2(index * item_size, 0)
			var child_size = Vector2(item_size, c.size.y)
			fit_child_in_rect(c, Rect2(pos, child_size))
			index += 1
