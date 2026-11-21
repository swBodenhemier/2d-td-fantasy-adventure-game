extends Node
var large_potion = {
	"sprite": "res://ASSETS/ART/ITEMS/large_health_potion.png",
	"type": "healing",
	"id" : 0,
	"count":1,
	"amount": 100,
	"stackSize": 3
}
var medium_potion = {
	"sprite": "res://ASSETS/ART/ITEMS/medium_health_potion.png",
	"type": "healing",
	"id": 1,
	"count":1,
	"amount": 50,
	"stackSize": 5
}
var small_potion = {
	"sprite": "res://ASSETS/ART/ITEMS/small_health_potion.png",
	"type": "healing",
	"id": 2,
	"count":1,
	"amount": 25,
	"stackSize": 6
}
var sword_1 = {
	"sprite": "res://ASSETS/ART/ITEMS/sword_1.png",
	"type": "weapon",
	"id": 3,
	"count":1,
	"amount": 25,
	"stackSize": 1
}
var sword_2 = {
	"sprite": "res://ASSETS/ART/ITEMS/sword_2.png",
	"type": "weapon",
	"id": 4,
	"count":1,
	"amount": 50,
	"stackSize": 1
}
var sword_3 = {
	"sprite": "res://ASSETS/ART/ITEMS/sword_3.png",
	"type": "weapon",
	"id": 5,
	"count":1,
	"amount": 75,
	"stackSize": 1
}
var sword_4 = {
	"sprite": "res://ASSETS/ART/ITEMS/sword_4.png",
	"type": "weapon",
	"id": 6,
	"count":1,
	"amount": 100,
	"stackSize": 1
}
var carrot = {
	"sprite": "res://ASSETS/ART/ITEMS/carrot.png",
	"type": "crop",
	"id": 7,
	"count":1,
	"amount": 50,
	"stackSize": 4
}
var corn = {
	"sprite": "res://ASSETS/ART/ITEMS/corn.png",
	"type": "crop",
	"id": 8,
	"count":1,
	"amount": 75,
	"stackSize": 3
}
var potato = {
	"sprite": "res://ASSETS/ART/ITEMS/potato.png",
	"type": "crop",
	"id": 9,
	"count":1,
	"amount": 25,
	"stackSize": 5
}
var tomato = {
	"sprite": "res://ASSETS/ART/ITEMS/tomato.png",
	"type": "crop",
	"id": 10,
	"count":1,
	"amount": 100,
	"stackSize": 6
}
func rand_item():
	var rand = [large_potion, medium_potion, small_potion,
	sword_1, sword_2, sword_3, sword_4,
	carrot, tomato, potato, corn]
	return rand[randi() % 11]
	
	
