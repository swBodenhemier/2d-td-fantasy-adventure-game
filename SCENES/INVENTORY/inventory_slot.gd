extends TextureButton

@onready var drop: Button = get_tree().get_first_node_in_group("drop_button")
signal enable_button
signal current_slot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#function selects
func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		enable_button.emit(self)
		drop.try_drop.connect(pass_current_slot)
	else:
		if drop.try_drop.is_connected(pass_current_slot):
			drop.try_drop.disconnect(pass_current_slot)
		self.button_pressed = toggled_on
		
	
func pass_current_slot() -> void:
	current_slot.emit(self)
		
