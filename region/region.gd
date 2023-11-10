extends Node3D

func init(game_data, valid_actions, region_data):
	
	for player_data in region_data.players:
		$Player.init(game_data, valid_actions, player_data)
		$Step.init(game_data, valid_actions, region_data.step)
	
	var resource_counter = 0
	var unit_counter = 0
	for permanent_data in region_data.unformed_permanents:
		var card_scene = load("res://card.tscn")
		var instance = card_scene.instantiate()
		
		print(permanent_data)
		
		if permanent_data.has("Resource"):
			var prototype_id = permanent_data.Resource.card_prototype_id
			var prototype = game_data.cards_db.prototypes[str(prototype_id)]
			instance.translate(Vector3(0.5 + resource_counter * 1.05, 0, 0))
			resource_counter += 1
			$Bounds/Resources.add_child(instance)
		
		if permanent_data.has("Unit"):
			var prototype_id = permanent_data.Unit.card.prototype_id
			var prototype = game_data.cards_db.prototypes[str(prototype_id)]
			instance.translate(Vector3(0.5 + unit_counter * 1.05, 0, 0))
			unit_counter += 1
			$Bounds/Units.add_child(instance)
			
		
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
