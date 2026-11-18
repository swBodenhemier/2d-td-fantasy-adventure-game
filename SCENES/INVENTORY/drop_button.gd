extends Button

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
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
