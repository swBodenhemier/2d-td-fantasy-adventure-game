extends TextureButton

@onready var group = get_tree().get_nodes_in_group("drop_button")
@onready var drop = group[0]
@onready var drop_stack = group[1]
signal enable_button
signal current_slot_single
signal current_slot_stack

#function selects the slot that the user clicks and toggles it on or off
func _on_toggled(toggled_on: bool) -> void:
	#if the slot is toggled on
	if toggled_on:
		#emit a signal to try and enable the drop button
		enable_button.emit(self)
		#connect the try to drop signal from the drob button to the pass_current_slot function
		drop.try_drop.connect(pass_current_slot_single)
		#connect the try to drop stack from the drop stack button to the pass_current_slot
		drop_stack.try_drop_stack.connect(pass_current_slot_stack)
	#otherwise
	else:
		#if the try_drop signal is connected
		if drop.try_drop.is_connected(pass_current_slot_single):
			#disconnected the signal
			drop.try_drop.disconnect(pass_current_slot_single)
		if drop_stack.try_drop_stack.is_connected(pass_current_slot_stack):
			drop_stack.try_drop_stack.disconnect(pass_current_slot_stack)
		#change the wether the current button is pressed to the toggled_on variable
		#this is only seen when you close out of the inventory or the slot you selected no longer has anything in it
		self.button_pressed = toggled_on
		
#this function passes the inventory slot to the inventory ui to be handled over there
func pass_current_slot_single() -> void:
	#emit the current_slot single signal
	current_slot_single.emit(self)
		
func pass_current_slot_stack() ->void:
	#emit the current_slot_stack signal
	current_slot_stack.emit(self)
