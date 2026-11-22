extends Button

@onready var drop = $"../DropButton"

signal try_drop_stack

func _ready():
	disabled = true
	drop.button_state_changed.connect(enable_disable_button)
	
func _on_pressed() -> void:
	try_drop_stack.emit()

func enable_disable_button(state: bool):
	disabled = state
