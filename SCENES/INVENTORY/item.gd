extends Sprite2D

var this = {}

func set_item(item: Dictionary):
	texture = item["sprite"]
	this = {
		"sprite": item["sprite"],
		"type": item["type"],
		"id": item["id"],
		"amount": item["amount"],
		"stackSize": item["stackSize"]
	}
	
