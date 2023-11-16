extends Node3D

var current_step: int
var history = []
var algomancer_cli_path = '/home/derek/RustroverProjects/algomancer/target/release/algomancer'

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if $CanvasLayer/ActionsList.is_anything_selected() == false: 
		return
	var item_idx = $CanvasLayer/ActionsList.get_selected_items()[0]
	var item_text = $CanvasLayer/ActionsList.get_item_text(item_idx)
	var action = JSON.parse_string(item_text)
	step(action)

func new_game():
	var output = []
	OS.execute(algomancer_cli_path, ['new', 'live_draft', '-f', 'wood', '-f', 'fire', '1v1'], output )
	
	var data = JSON.parse_string(output[0])
	history_add(data, null)
	
	return data

func get_actions(game_data):
	var input = JSON.stringify(game_data).replace('"', '\\"')
	var output = []
	OS.execute(algomancer_cli_path, ['action', 'ls', input], output)
	return JSON.parse_string(output[0])

func apply_action(action):
	var input_state = JSON.stringify(game_data).replace('"', '\\"')
	var input_action = JSON.stringify(action).replace('"', '\\"')
	var output = []
	OS.execute(algomancer_cli_path, ['action', 'apply', input_state, input_action], output)
	
	var data = JSON.parse_string(output[0])
	history_add(data, action)
	
	return data


func history_add(game_data, applied_action):
	history.append({'state': game_data, 'action': applied_action})
	history_list_render()
	

func history_list_render():
	$CanvasLayer/HistoryList.clear()
	history.reverse()
	
	for step in history:
		if step.action == null: 
			$CanvasLayer/HistoryList.add_item("Initial State")
		else:
			$CanvasLayer/HistoryList.add_item(JSON.stringify(step.action))
	
	history.reverse()

var game_data = {}
var valid_actions = {}

func step(action):
	history.resize(current_step + 1)
	
	print('taking step with action', action)
	game_data = apply_action(action)
	valid_actions = get_actions(game_data)
	current_step += 1
	reset()
	init()
	


func remove_all_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func reset():
	$CanvasLayer/ActionsList.clear()
	remove_all_children($CommonDeckParent)
	remove_all_children($Regions)
	

func init():
	for action in valid_actions:
		$CanvasLayer/ActionsList.add_item(str(action))
	
	history_list_render()
	
	var i = 0
	var side_len = 1.75 # size of player space 
	var radius = ngon_radius(side_len, game_data.state.regions.size())
	for region_data in game_data.state.regions: 
		var region_scene = load("res://region/region.tscn")
		var instance = region_scene.instantiate()
		instance.init(game_data, valid_actions, region_data)
		
		var r = i * PI * 2 / game_data.state.regions.size()
		var v = Vector3(radius, 0, 0)
	
		instance.look_at_from_position(v.rotated(Vector3.UP, r), position, Vector3.UP)
		
		$Regions.add_child(instance)
	
		i += 1
	
	if game_data.state.common_deck != null:
		var deck_data = game_data.state.common_deck
		var deck_scene = load("res://deck.tscn")
		var deck_instance = deck_scene.instantiate()
		deck_instance.init(game_data, valid_actions, deck_data)
		$CommonDeckParent.add_child(deck_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.action.connect(_handle_action)
	game_data = new_game()
	valid_actions = get_actions(game_data)
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ngon_radius(l: float, n: int) -> float:
	if n < 3:
		return l / 2
	return l / (2.0 * sin(PI / n))


func _handle_action(action):
	print('action from game ', action)
	step(action)


func _on_history_list_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return
	
	current_step = history.size() - (index + 1)
	game_data = history[current_step].state
	valid_actions = get_actions(game_data)
	
	reset()
	init()





















