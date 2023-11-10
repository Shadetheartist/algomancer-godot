extends Node3D

var card_id: int
var card_name: String

var hovered: bool
var default_border_color = Color.BLACK
var card_valid_actions = []

# Called when the node enters the scene tree for the first time.
func init(game_data, valid_actions, card_data):
	default_border_color = Color.BLACK
	card_valid_actions = []
	
	for child in $Conversion.get_children():
		child.hide()
	
	var card_proto = game_data.cards_db.prototypes[str(card_data.prototype_id)]
	
	self.card_name = card_proto.name
	self.card_id = card_data.card_id
	
	$Label.text = card_proto.name
	
	var card_type = card_proto.card_type.keys()[0]
	var card_timing = card_proto.card_type[card_type]
	$Type.text = card_type
	$Timing.text = card_timing
	
	for action in valid_actions:
		if action.has("RecycleForResource"):
			if action.RecycleForResource.card_id == card_data.card_id:
				card_has_action(action)
				var resource_node = $Conversion.find_child(action.RecycleForResource.resource_type)
				if resource_node != null:
					resource_node.show()
		
		if action.has("PlayCard"):
			if action.PlayCard.card_id == card_data.card_id:
				card_has_action(action)


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
				"RecycleForResource": { 
					"card_id": self.card_id, 
					"resource_type": node.name 
				}
			})


func _on_area_3d_mouse_entered():
	self.hovered = true
	set_border_color(Color.SKY_BLUE)
	
	pass # Replace with function body.


func _on_area_3d_mouse_exited():
	self.hovered = false
	set_border_color(null)