extends Node3D

func off_all():
	off($PrecombatPhase)
	off($PrecombatPhase/UntapMarker)
	off($PrecombatPhase/DrawMarker)
	off($PrecombatPhase/DraftMarker)
	off($PrecombatPhase/PassPackMarker)
	off($PrecombatPhase/ITManaMarker)
	off($PrecombatPhase/ITHasteMarker)
	off($PrecombatPhase/NITManaMarker)
	off($PrecombatPhase/NITHasteMarker)
	
	off($CombatPhase)
	off($CombatPhase/Attack)
	off($CombatPhase/AfterAttackPriorityWindow/Rotate/Cube)
	off($CombatPhase/Block)
	off($CombatPhase/AfterBlockPriorityWindow/Rotate/Cube)
	off($CombatPhase/Damage)
	off($CombatPhase/AfterCombatPriorityWindow/Rotate/Cube)
	
	off($CombatPhase2)
	off($CombatPhase2/Attack)
	off($CombatPhase2/AfterAttackPriorityWindow/Rotate/Cube)
	off($CombatPhase2/Block)
	off($CombatPhase2/AfterBlockPriorityWindow/Rotate/Cube)
	off($CombatPhase2/Damage)
	off($CombatPhase2/AfterCombatPriorityWindow/Rotate/Cube)
	
	off($MainPhase)
	off($MainPhase/Regroup)
	off($MainPhase/ITMain)
	off($MainPhase/NITMain)
	
func off(marker):
	marker.get_active_material(0).albedo_color = Color.BLACK
	
func on(marker):
	marker.get_active_material(0).albedo_color = Color.YELLOW

func init(game_data, valid_actions, step_data):
	off_all()
	if step_data.phase == "PlanningPhase":
		$PrecombatPhase.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.step == "Refresh":
			on($PrecombatPhase/UntapMarker)
		elif step_data.step == "Draw":
			on($PrecombatPhase/DrawMarker)
		elif step_data.step == "Draft":
			on($PrecombatPhase/DraftMarker)
		elif step_data.step == "PassPack":
			on($PrecombatPhase/PassPackMarker)
		elif step_data.step == "Mana":
			if step_data.team == "IT":
				on($PrecombatPhase/ITManaMarker)
			else: 
				on($PrecombatPhase/NITManaMarker)
		elif step_data.step == "Haste":
			if step_data.team == "IT":
				on($PrecombatPhase/ITHasteMarker)
			else: 
				on($PrecombatPhase/NITHasteMarker)
			
	elif step_data.phase == "BattlePhaseA" || step_data.phase == "BattlePhaseB":
		var entity = $CombatPhase if step_data.phase == "BattlePhaseA" else $CombatPhase2
		entity.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.step == "Attack":
			on(entity.find_child("Attack"))
		elif step_data.step == "AfterAttackPriorityWindow":
			on(entity.find_child("AfterAttackPriorityWindow/Rotate/Cube"))
		elif step_data.step == "Block":
			on(entity.find_child("Block"))
		elif step_data.step == "AfterBlockPriorityWindow":
			on(entity.find_child("AfterBlockPriorityWindow/Rotate/Cube"))
		elif step_data.step == "Damage":
			on(entity.find_child("Damage"))
		elif step_data.step == "AfterCombatPriorityWindow":
			on(entity.find_child("AfterCombatPriorityWindow/Rotate/Cube"))

	elif step_data.phase == "DeploymentPhase":
		$MainPhase.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.step == "Regroup":
			on($MainPhase/Regroup)
		elif step_data.step == "Deployment":
			if step_data.team == "IT":
				on($MainPhase/ITMain)
			else: 
				on($MainPhase/NITMain)
			
	print(step_data)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
