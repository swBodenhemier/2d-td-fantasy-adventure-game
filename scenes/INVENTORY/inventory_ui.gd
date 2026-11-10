extends CanvasLayer

@export var slot_scene: PackedScene

var slot_grid: GridContainer

var slots: Array[TextureButton] = []

func _ready() -> void:
	slot_grid = $Panel/InventoryContainer/SlotGrid
	_populate_inventory_slots()
	print(slot_grid.get_children())

func _populate_inventory_slots(): 
	for i in range(12):
		var instance = slot_scene.instantiate()
		slots.append(instance)
		slot_grid.add_child(instance)
