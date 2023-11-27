extends Node3D

func init(game_data, valid_actions, permanent_data):
	var prototype_id = permanent_data.card_prototype_id
	var prototype = game_data.cards_db.prototypes[str(prototype_id)]
	
	print(permanent_data)
	print(prototype.name, ' | ', prototype.card_type)

	var image_name: String
	if permanent_data.type == "Resource":
		image_name = prototype.name + "-Resource.jpg"
	
	var path = "res://assets/card_images/" + image_name
	var image = Image.load_from_file(path)
	if image != null:
		var image_texture = ImageTexture.create_from_image(image)
		if image_texture != null:
			$Sprite3D.texture = image_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
