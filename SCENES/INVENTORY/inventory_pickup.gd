class_name InventoryPickup
extends Area2D

func _ready():
	pass
#function: on_area_entered()
	   #if the area is entered by the player and there is an item within the area
			  #try adding the item to the inventory slot by using the function add_item()
	#if the item was added delete the item node from the world
func _on_area_entered(area: Area2D) -> void:
	var bodies = area.get_overlapping_bodies()
	if bodies is Item:
		#emit a signal to item Pickup
		return
