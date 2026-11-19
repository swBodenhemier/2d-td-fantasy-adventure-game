class_name InventoryPickup
extends Area2D

signal try_pickup


#function: on_area_entered()
	   #if the area is entered by the player and there is an item within the area
			  #try adding the item to the inventory slot by using the function add_item()
	#if the item was added delete the item node from the world
func _on_area_entered(area: Area2D) -> void:
	#check if the area is of class Item
	if area.get_parent() is Item:
		#check if the item is pickupable
		if area.get_parent().pickupable:
			#emit a signal with the item node
			try_pickup.emit(area.get_parent())
