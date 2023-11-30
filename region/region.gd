extends Node3D

func init(game_data, valid_actions, region_data):
	
	for player_data in region_data.players:
		$Player.init(game_data, valid_actions, player_data)
		$Step.init(game_data, valid_actions, region_data.step)
	
	var resource_counter = 0
	var unit_counter = 0
	for permanent_data in region_data.unformed_permanents:
		var card_scene = load("res://permanent.tscn")
		var instance = card_scene.instantiate()
		
		if permanent_data.type == "Resource":
			resource_counter += 1
			instance.init(game_data, valid_actions, permanent_data)
			instance.translate(Vector3(resource_counter * 0.33, 0, 0))
			$Bounds/Resources.add_child(instance)
		elif permanent_data.type == "Unit":
			unit_counter += 1
			instance.init(game_data, valid_actions, permanent_data)
			instance.translate(Vector3(unit_counter * 1.05, 0, 0))
			$Bounds/Units.add_child(instance)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
