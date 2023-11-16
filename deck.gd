extends Node3D


func init(game_data, valid_actions, deck_data):
	var num_cards = deck_data.Deck.cards.size()
	$Mesh.translate(Vector3(0, $Mesh.scale.y * num_cards, 0))
	
	$Mesh.scale_object_local(Vector3(1, num_cards / 2, 1))
	$NumCardsLabel.translate(Vector3(0, $Mesh.scale.y, 0))
	$NumCardsLabel.text = str(deck_data.Deck.cards.size())
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
