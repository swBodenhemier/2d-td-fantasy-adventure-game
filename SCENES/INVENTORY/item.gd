extends Sprite2D

var this = {}

func set_item(item: Dictionary):
	texture = item["sprite"]
	this = {
		"sprite": item["sprite"],
		"type": item["type"],
		"amount": item["amount"],
		"stackable": item["stackable"]
	}
	
