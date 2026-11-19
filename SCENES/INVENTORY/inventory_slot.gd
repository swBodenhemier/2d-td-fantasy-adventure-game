extends TextureButton

@onready var drop: Button = get_tree().get_first_node_in_group("drop_button")

signal enable_button
signal current_slot

#function selects the slot that the user clicks and toggles it on or off
func _on_toggled(toggled_on: bool) -> void:
	#if the slot is toggled on
	if toggled_on:
		#emit a signal to try and enable the drop button
		enable_button.emit(self)
		#connect the try to drop signal from the drob button to the pass_current_slot function
		drop.try_drop.connect(pass_current_slot)
	#otherwise
	else:
		#if the try_drop signal is connected
		if drop.try_drop.is_connected(pass_current_slot):
			#disconnected the signal
			drop.try_drop.disconnect(pass_current_slot)
		#change the wether the current button is pressed to the toggled_on variable
		#this is only seen when you close out of the inventory or the slot you selected no longer has anything in it
		self.button_pressed = toggled_on
		
#this function passes the inventory slot to the inventory ui to be handled over there
func pass_current_slot() -> void:
	#emit the current_slot signal
	current_slot.emit(self)
		
