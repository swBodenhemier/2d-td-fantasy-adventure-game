extends CanvasLayer

@export var slot_scene: PackedScene
@export var item_scene: PackedScene

var drop_button: Button
var slot_grid: GridContainer
var slots: Array[TextureButton] = []

var slot_fill_array: Array[int] = []
var items_array: Array[Dictionary] = []
var placed =  false
var number_slots = 12
var inventory_pickup: InventoryPickup

signal inventory_changed
signal disable_button
signal deselect_slot

func _ready() -> void:
	slot_grid = $Panel/InventoryContainer/SlotGrid
	drop_button = $Panel/InventoryContainer/DropButton
	
	_populate_inventory_slots()
	print(slot_grid.get_children())
	var pickup_node = get_node("../InventoryPickup")
	pickup_node.connect("try_pickup", add_item)
	inventory_changed.connect(_on_inventory_changed)
	disable_button.connect(drop_button.slot_emptied)

func _populate_inventory_slots(): 
	for i in range(12):
		#initialize the slot to empty in both its dictionary array and count array
		slot_fill_array.append(0)
		items_array.append({})
		var instance = slot_scene.instantiate()
		#connect the slots enable_button signal to the on_slot pressed function in the drop button
		instance.enable_button.connect(drop_button._on_slot_pressed)
		#connect the current slot signal to the inventory ui'd function drop item
		instance.current_slot.connect(drop_item)
		#connect the signal closed to the instance so the slot gets unselected\
		deselect_slot.connect(instance._on_toggled)
		#append the instance to the slots array
		slots.append(instance)
		#add the slot as a child of the slot grid
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
				inventory_changed.emit(i, slot_fill_array[i], items_array[i])
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
			inventory_changed.emit(i, slot_fill_array[i], items_array[i])
			#return true
			return true
	#return false
	return false


#add the item to the inventory slot
#function: add_item
func add_item(item):
	placed = false
	#check whether the item is stackable or not
			#if it is stackable
	if item.this["stackSize"] != 1:
	#Search each slot for a stackable item of the same type 
	#use the boolean to handle the return					
	#function: search_for_stackable()
		placed = search_for_stackable(item.this)
	#check if the item was not placed
	if !placed:
		#try adding the item to an empty slot and use the boolean to handle the return
		#function: search_for_empty_slot()
		placed = search_for_empty_slot(item.this)
	#return the boolean variable
	if placed:
		item.queue_free()
		
func drop_item(slot):
	var slot_index = find_index(slot)
	#subtract 1 from the count
	slot_fill_array[slot_index] -= 1
	#place the item back into the world
	place_back_into_world(items_array[slot_index])
	if slot_fill_array[slot_index] == 0:
		#clear the dictionary
		items_array[slot_index] = {}
	#emit a signal to inventory changed
	inventory_changed.emit(slot_index, slot_fill_array[slot_index], items_array[slot_index])
	
	
func find_index(slot):
	for i in range(number_slots):
		#check for the slot in the slots array
		if slot == slots[i]:
			return i
			
func place_back_into_world(item: Dictionary):
	var dropped_item = item_scene.instantiate()
	dropped_item.set_item(item)
	dropped_item.position = get_parent().position
	get_parent().get_parent().add_child(dropped_item)

func _on_inventory_changed(changed_index: int, count: int, item:Dictionary):
	if count == 1:	
		slots[changed_index].get_child(0).texture = load(item["sprite"])
		slots[changed_index].get_child(1).text = ""
	elif count > 1:
		slots[changed_index].get_child(1).text = str(count)
	else:
		#clear the display
		slots[changed_index].get_child(0).texture = null
		slots[changed_index].get_child(1).text = ""
		#emit a signal back to the drop button to disable it
		deselect_slot.emit(false)
		disable_button.emit()
		

func _input(Event: InputEvent) -> void:
	if Event.is_action_pressed("Inventory"):
		visible = !visible
		#deslect the slot
		deselect_slot.emit(false)
		#disable the drop button again
		disable_button.emit()


func _on_visibility_changed() -> void:
	get_tree().paused = visible
