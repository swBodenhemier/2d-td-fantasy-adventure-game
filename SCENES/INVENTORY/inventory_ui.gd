extends CanvasLayer

@export var slot_scene: PackedScene

var slot_grid: GridContainer
var slots: Array[TextureButton] = []

var slot_fill_array: Array[int] = []
var items_array: Array[Dictionary] = []
var placed =  false
var number_slots = 12
var inventory_pickup: InventoryPickup

func _ready() -> void:
	slot_grid = $Panel/InventoryContainer/SlotGrid
	
	_populate_inventory_slots()

func _populate_inventory_slots(): 
	for i in range(12):
		#initialize the slot to empty in the boolean array
		slot_fill_array.append(0)
		items_array.append({})
		var instance = slot_scene.instantiate()
		slots.append(instance)
		slot_grid.add_child(instance)
		
func search_for_stackable(item: Dictionary):
	#for each slot
	for i in range(number_slots):
		#Check if the target item matches the item in the slot and the current stack size is less 		
		#than the stack limit of the item
		if(!items_array[i].is_empty()):
			if(item["id"] == items_array[i]["id"] and slot_fill_array[i] < item["stackSize"]):
				
				slot_fill_array[i] += 1
				#emit a signal to inventory_changed
				return true
	return false


#this function should take an item as an argument, run through each item slot until it finds and #empty slot to place the item and return true if the item was placed and false if there are no 

func search_for_empty_slot(item: Dictionary):
	#for each slot
	for i in range(number_slots):
		#check if the slot is empty
		if(slot_fill_array[i] == 0):
			#assign the item to the slot
			items_array[i] = item
			#increment the value
			slot_fill_array[i] += 1
			#emit a signal to inventory_changed
			#return true
			return true
	#return false
	return false


#add the item to the inventory slot
#function: add_item
func add_item(item):
	#check whether the item is stackable or not
			#if it is stackable
	if item["stackSize != 1"]:
	#Search each slot for a stackable item of the same type 
	#use the boolean to handle the return					
	#function: search_for_stackable()
		placed = search_for_stackable(item)
	#check if the item was not placed
	if !placed:
		#try adding the item to an empty slot and use the boolean to handle the return
		#function: search_for_empty_slot()
		placed = search_for_empty_slot(item)
	#return the boolean variable
	if placed:
		#emit a signal back to item_pickup gd to remove the item node
		return

func _input(Event: InputEvent) -> void:
	if Event.is_action_pressed("Inventory"):
		visible = !visible


func _on_visibility_changed() -> void:
	get_tree().paused = visible
