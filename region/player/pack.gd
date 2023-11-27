extends Node3D


func init(game_data, valid_actions, player_data, pack_data):
	$model.show()
	
	if pack_data == null: 
		$model.hide()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
