extends Node3D


func init(game_data, valid_actions, player_data, hand_data):
	
	# todo: figure out how to constrain the cards to the bounds rect, with squishing
	
	var offset = Vector3(-hand_data.cards.size()*1.05/2 + 0.5,0,0)
	var i = 0
	for card_data in hand_data.cards:
		var card_scene = load("res://card.tscn")
		var instance = card_scene.instantiate()
		instance.init(game_data, valid_actions, player_data, card_data)
		instance.translate(Vector3(i * 1.05, 0, 0) + offset)
		add_child(instance)
		i += 1
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
