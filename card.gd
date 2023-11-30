extends Node3D

var card_id: int
var controller_player_id: int
var card_name: String

var hovered: bool
var default_border_color = Color.BLACK
var card_valid_actions = []

# Called when the node enters the scene tree for the first time.
func init(game_data, valid_actions, player_data, card_data):
	default_border_color = Color.BLACK
	card_valid_actions = []
	
	for child in $Conversion.get_children():
		child.hide()
	
	var card_proto = game_data.cards_db.prototypes[str(card_data.prototype_id)]
	
	self.card_name = card_proto.name
	self.card_id = card_data.card_id
	self.controller_player_id = player_data.id
	
	$Label.text = card_proto.name
	
	var card_type = card_proto.card_type.keys()[0]
	var card_timing = "Default"
	if card_type == "Unit" || card_type == "Spell": 
		card_timing = card_proto.card_type[card_type].timing
		
	$Type.text = card_type
	$Timing.text = card_timing
	
	if valid_actions:
		for action in valid_actions:
			if action.type == "RecycleForResource":
				if action.card_id == card_data.card_id:
					card_has_action(action)
					var resource_node = $Conversion.find_child(action.resource_type)
					if resource_node != null:
						resource_node.show()
			
			if action.type == "PlayCard":
				if action.card_id == card_data.card_id:
					card_has_action(action)
	
	var image_name = card_proto.std_name + ".jpg"
	$Sprite3D.texture = load("res://assets/card_images/" + image_name)

func card_has_action(action):
	default_border_color = Color.GREEN_YELLOW
	set_border_color(Color.GREEN_YELLOW)
	card_valid_actions.append(action)

	
func set_border_color(color):
	if color == null:
		color = default_border_color
	
	var material = $Front.get_active_material(0)
	var base_material = material as BaseMaterial3D
	base_material.albedo_color = color


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $Conversion.get_children():
		var area = child.get_child(0) as Area3D
		area.input_event.connect(handle_resource_conversion_input_event.bind(child))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_resource_conversion_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, node: Node3D):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			EventBus.action.emit({ 
				"issuer_player_id": self.controller_player_id,
				"type": "RecycleForResource",
				"card_id": self.card_id, 
				"resource_type": node.name 
			})


func _on_area_3d_mouse_entered():
	self.hovered = true
	set_border_color(Color.SKY_BLUE)
	
	pass # Replace with function body.


func _on_area_3d_mouse_exited():
	self.hovered = false
	set_border_color(null)
