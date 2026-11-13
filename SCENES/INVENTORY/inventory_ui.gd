extends CanvasLayer

@export var slot_scene: PackedScene

var slot_grid: GridContainer
var slots: Array[TextureButton] = []

var inventory_pickup: InventoryPickup

func _ready() -> void:
	slot_grid = $Panel/InventoryContainer/SlotGrid
	
	_populate_inventory_slots()

func _populate_inventory_slots(): 
	for i in range(12):
		var instance = slot_scene.instantiate()
		slots.append(instance)
		slot_grid.add_child(instance)

func _input(Event: InputEvent) -> void:
	if Event.is_action_pressed("Inventory"):
		visible = !visible

#the function takes a slot as an argument and updates the display when the item count has changed
#function on_inventory_changed()
	#check if the count for the item is above one
		#set the labels count equal to the items count
		#make the count label visible
	#otherwise 
		#make the count label invisible
	#check if the count for the item is 0
		#clear the slot of the icon
	#otherwise check if the count for the item is 1 and there is no icon already
		#add the icon to the slot
