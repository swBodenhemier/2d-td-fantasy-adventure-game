extends Button

signal try_drop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set the button to diabled at the start
	disabled = true

func _on_slot_pressed(slot):
	#if the node has something inside enable the button
	var slot_icon = slot.get_child(0)
	if slot_icon.texture != null:
		disabled = false
	#otherwise disable the button
	else:
		disabled = true

#this function disables the drop button when a slot is emptied
func slot_emptied():
	#set the disabled variable to true
	disabled = true

#this function handles dropping an item when the srop button is pressed
func _on_pressed() -> void:
	#emit the signal to try drop to the slot script
	try_drop.emit()
	
