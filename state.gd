extends Node3D

var current_step: int
var history = []
var algomancer_cli_path = '/home/derek/RustroverProjects/algomancer/target/release/algomancer'
var state_path = '/tmp/state.json'
var action_path = '/tmp/action.json'
var actions_path = '/tmp/actions.json'
var mutations_path = '/tmp/mutations.json'


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.action.connect(_handle_action)
	game_data = new_game()
	valid_actions = get_actions(game_data)
	history_add(game_data, valid_actions, null)
	init()



func new_game():
	var output = []
	OS.execute(algomancer_cli_path, ['new', '-o', state_path, 'live_draft', '-f', 'wood', '-f', 'fire', '1v1'], output)
	return read_json_from_file(state_path)

func get_actions(game_data):
	var stderr = []
	OS.execute(algomancer_cli_path, ['action', 'ls', '-f', state_path, '-o', actions_path], stderr, true)
	var result = read_json_from_file(actions_path)
	
	return result

func apply_action(action):
	write_to_file_as_json(action_path, action)
	
	var stderr = []
	var args = ['action', 'apply', '-f', state_path, '-o', state_path, '-a', action_path, '-m', mutations_path]
	OS.execute(algomancer_cli_path, args, stderr, true)
	
	var data = read_json_from_file(state_path)
	
	if data == null:
		push_error(stderr)
		return null
	
	var mutations = read_json_from_file(mutations_path)
	history_add(data, action, mutations)
	
	return data


func history_add(game_data, applied_action, mutations):
	history.append({'state': game_data, 'action': applied_action, 'mutations': mutations})
	history_list_render()
	
func mutations_list_render():
	var step = history[current_step]
	if step.mutations != null:
		step.mutations.reverse()
		for mutation in step.mutations:
			$CanvasLayer/MutationsList.add_item(mutation.type + ': ' + JSON.stringify(mutation))
			pass
		step.mutations.reverse()
		
func history_list_render():
	$CanvasLayer/HistoryList.clear()
	$CanvasLayer/MutationsList.clear()
	
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
	if game_data == null: 
		return
		
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
	$CanvasLayer/MutationsList.clear()
	remove_all_children($CommonDeckParent)
	remove_all_children($Regions)
	

func init():
	if valid_actions:
		for action in valid_actions:
			$CanvasLayer/ActionsList.add_item(str(action))
	
	history_list_render()
	mutations_list_render()
	
	if game_data == null:
		return
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func write_to_file_as_json(file, data):
	var data_json = JSON.stringify(data)
	var fileAccess = FileAccess.open(file, FileAccess.WRITE)
	fileAccess.store_line(data_json)
	fileAccess.close()
	return data
	
func read_json_from_file(file):
	var fileAccess = FileAccess.open(file, FileAccess.READ)
	var json_data = fileAccess.get_as_text()
	fileAccess.close()
	var data = JSON.parse_string(json_data)
	return data
	
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


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if $CanvasLayer/ActionsList.is_anything_selected() == false: 
		return
	var item_idx = $CanvasLayer/ActionsList.get_selected_items()[0]
	var item_text = $CanvasLayer/ActionsList.get_item_text(item_idx)
	var action = JSON.parse_string(item_text)
	step(action)
















