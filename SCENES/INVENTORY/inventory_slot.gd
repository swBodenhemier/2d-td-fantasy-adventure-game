extends TextureButton

signal try_drop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#function selects
func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		try_drop.emit(self)
	
