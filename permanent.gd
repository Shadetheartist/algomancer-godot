extends Node3D

func init(game_data, valid_actions, permanent_data):
	var prototype_id = permanent_data.card_prototype_id
	var prototype = game_data.cards_db.prototypes[str(prototype_id)]
	
	print(permanent_data)
	print(prototype.name, ' | ', prototype.card_type)

	var image_name = prototype.std_name + ".jpg"
	$Sprite3D.texture = load("res://assets/card_images/" + image_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
