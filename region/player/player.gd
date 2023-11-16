extends Node3D

# break after 4 teams 
var team_colors = [Color.RED, Color.BLUE, Color.WHITE, Color.BLACK]

func init(game_data, valid_actions, player_data):
	$Body/Head.get_active_material(0).albedo_color = team_colors[player_data.team_id - 1]
	$Hand.init(game_data, valid_actions, player_data.hand)
	# $Discard.init(game_data, valid_actions, player_data.discard)
	$PlayerNameLabel.text = "Player #" + str(player_data.id)
	$InfoPanel/InfoLabel.text = "HP: " + str(player_data.health) + "\n" + "Team: " + str(player_data.team_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
