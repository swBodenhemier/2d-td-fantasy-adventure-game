extends CanvasLayer

@export var slot_scene: PackedScene
@export var item_scene: PackedScene

var drop_button: Button
var slot_grid: GridContainer
var slots: Array[TextureButton] = []

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
	var pickup_node = get_node("../InventoryPickup")
	pickup_node.connect("try_pickup", add_item)
	inventory_changed.connect(_on_inventory_changed)
	disable_button.connect(drop_button.slot_emptied)

func _populate_inventory_slots(): 
	for i in range(12):
		#initialize the slot to empty in both its dictionary array and count array
		items_array.append({})
		#create an instance of a slot scene
		var instance = slot_scene.instantiate()
		#connect the slots enable_button signal to the on_slot pressed function in the drop button
		instance.enable_button.connect(drop_button._on_slot_pressed)
		#connect the current slot signal to the inventory ui'sfunction drop item
		instance.current_slot_single.connect(drop_item)
		#connect the current slot stack signal to the inventory uis function drop stack
		instance.current_slot_stack.connect(drop_stack)
		#connect the signal closed to the instance so the slot gets unselected
		deselect_slot.connect(instance._on_toggled)
		#append the instance to the slots array
		slots.append(instance)
		#add the slot as a child of the slot grid
		slot_grid.add_child(instance)
		
#ADD ITEM FUNCTIONS
func search_for_stackable(item: Dictionary):
	#for each slot
	for i in range(number_slots):
		#check if thetre is something in the current dictionary
		if(!items_array[i].is_empty()):
			#check if the item id is the same as the item in the current dictionary and check if the current stack size is less than the items max stack size
			if(item["id"] == items_array[i]["id"] and items_array[i]["count"] < item["stackSize"]):
				var new_count = items_array[i]["count"] + item["count"]
				#add 1 to the count array at the current slots position
				items_array[i]["count"] = item["stackSize"] if new_count > item["stackSize"] else new_count
				#emit a signal to inventory_changed
				inventory_changed.emit(i, items_array[i]["count"], items_array[i])
				if new_count > item["stackSize"]:
					item["count"] = new_count - item["stackSize"]
					return search_for_stackable(item)
				#return true
				return true
	#return false
	return false


#this function should take an item as an argument, run through each item slot until it finds and #empty slot to place the item and return true if the item was placed and false if there are no 
func search_for_empty_slot(item: Dictionary):
	#for each slot
	for i in range(number_slots):
		#check if the slot is empty
		if(items_array[i].is_empty()):
			#assign the item to the slot
			items_array[i] = item
			#emit a signal to inventory_changed
			inventory_changed.emit(i, items_array[i]["count"], items_array[i])
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
		#remove the item from the world
		item.queue_free()

#DROP ITEMS FUNCTIONS
#this function should manage other functions involved in dropping teh item
func drop_item(slot):
	#get the index of the current slot
	#function: find_index
	var slot_index = find_index(slot)
	#place the item back into the world if the slot is above 1
	place_back_into_world(items_array[slot_index],false)
	#subtract 1 from the count at the index returned
	items_array[slot_index]["count"] -= 1
	var count = items_array[slot_index]["count"]
	#check if the current count is now 0
	if items_array[slot_index]["count"] == 0:
		#clear the dictionary
		items_array[slot_index] = {}
	#emit a signal to inventory changed
	inventory_changed.emit(slot_index, count, items_array[slot_index])
	
#this function is involved in finding the index of a slot node
func find_index(slot):
	#for each slot
	for i in range(number_slots):
		#check if the slot matched the current slot
		if slot == slots[i]:
			#return the index
			return i

#this function should handle placing the items back into the world taking a dictionary as an argument
func place_back_into_world(item: Dictionary, drop_stacked: bool):
	#instantiate an item scene
	var dropped_item = item_scene.instantiate()
	#set the items content to the passed dictionary
	dropped_item.set_item(item)
	if drop_stacked:
		dropped_item.set_count(item)
	#set the items position to the players position
	dropped_item.position = get_parent().position
	#add the node as a child of the mainGameLevel node
	get_parent().get_parent().add_child(dropped_item)


#DROP STACK FUNCTIONS
func drop_stack(slot):
	#find the index of the slot
	var slot_index = find_index(slot)
	#place the item back into the world
	place_back_into_world(items_array[slot_index], true)
	#set the items count to 0
	items_array[slot_index]["count"] = 0
	#pass the signal back to inventory changed
	inventory_changed.emit(slot_index, items_array[slot_index]["count"], items_array[slot_index])
	#reinitialize the dictionary to empty
	items_array[slot_index] = {}
	


#this fujnction should handle changing the display of the inventory, updating when a slot has changed
func _on_inventory_changed(changed_index: int, count: int, item:Dictionary):
	#check if the item count is 1
	if count == 1:	
		#check if the there is nothing assigned to the slots ItemIcon texture
		if slots[changed_index].get_child(0).texture == null:
			#assign the slots ItemIcon texture to the picked up item's sprite
			slots[changed_index].get_child(0).texture = load(item["sprite"])
		#set the count lable to empty
		slots[changed_index].get_child(1).text = ""
	#otherwise if the item count is greater than 1
	elif count > 1:
		slots[changed_index].get_child(0).texture = load(item["sprite"])
		#set the lable's text to the count
		slots[changed_index].get_child(1).text = str(count)
	#otherwise the slot has hit 0
	else:
		#set the ItemIcon texture to null
		slots[changed_index].get_child(0).texture = null
		#set the text of the lable to empty
		slots[changed_index].get_child(1).text = ""
		#emit a signal back to the selected slot to untoggle it
		deselect_slot.emit(false)
		#emit a signal back to the drop button to disable it
		disable_button.emit()
		
#INVENTORY VISABILLITY FUNCTIONS
func _input(Event: InputEvent) -> void:
	if Event.is_action_pressed("Inventory"):
		visible = !visible
		#deslect the slot
		deselect_slot.emit(false)
		#disable the drop button again
		disable_button.emit()


func _on_visibility_changed() -> void:
	get_tree().paused = visible
