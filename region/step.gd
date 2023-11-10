extends Node3D

func off_all():
	off($PrecombatPhase)
	off($PrecombatPhase/UntapMarker)
	off($PrecombatPhase/DrawMarker)
	off($PrecombatPhase/DraftMarker)
	off($PrecombatPhase/PassPackMarker)
	off($PrecombatPhase/ITManaMarker)
	off($PrecombatPhase/NITManaMarker)
	
	off($CombatPhase/Attack)
	off($CombatPhase/AfterAttackPriorityWindow/Rotate/Cube)
	off($CombatPhase/Block)
	off($CombatPhase/AfterBlockPriorityWindow/Rotate/Cube)
	off($CombatPhase/Damage)
	off($CombatPhase/AfterCombatPriorityWindow/Rotate/Cube)
	
	off($CombatPhase2/Attack)
	off($CombatPhase2/AfterAttackPriorityWindow/Rotate/Cube)
	off($CombatPhase2/Block)
	off($CombatPhase2/AfterBlockPriorityWindow/Rotate/Cube)
	off($CombatPhase2/Damage)
	off($CombatPhase2/AfterCombatPriorityWindow/Rotate/Cube)
	
	off($MainPhase/Regroup)
	off($MainPhase/ITMain)
	off($MainPhase/NITMain)
	
func off(marker):
	marker.get_active_material(0).albedo_color = Color.BLACK
	
func on(marker):
	marker.get_active_material(0).albedo_color = Color.YELLOW

func init(game_data, valid_actions, step_data):
	off_all()
	if step_data.has("PrecombatPhase"):
		$PrecombatPhase.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.PrecombatPhase == "Untap":
			on($PrecombatPhase/UntapMarker)
		elif step_data.PrecombatPhase == "Draw":
			on($PrecombatPhase/DrawMarker)
		elif step_data.PrecombatPhase == "Draft":
			on($PrecombatPhase/DraftMarker)
		elif step_data.PrecombatPhase == "PassPack":
			on($PrecombatPhase/PassPackMarker)
		elif step_data.PrecombatPhase == "ITMana":
			on($PrecombatPhase/ITManaMarker)
		elif step_data.PrecombatPhase == "NITMana":
			on($PrecombatPhase/NITManaMarker)
			
	elif step_data.has("CombatPhaseA"):
		$CombatPhase.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.CombatPhaseA == "ITPrepareFormation":
			on($CombatPhase/Attack)
		elif step_data.CombatPhaseA == "ITAttack":
			on($CombatPhase/Attack)
		elif step_data.CombatPhaseA == "AfterITAttackPriorityWindow":
			on($CombatPhase/AfterAttackPriorityWindow/Rotate/Cube)
		elif step_data.CombatPhaseA == "NITBlock":
			on($CombatPhase/Block)
		elif step_data.CombatPhaseA == "AfterNITBlockPriorityWindow":
			on($CombatPhase/AfterBlockPriorityWindow/Rotate/Cube)
		elif step_data.CombatPhaseA == "Damage":
			on($CombatPhase/Damage)
		elif step_data.CombatPhaseA == "AfterCombatPriorityWindow":
			on($CombatPhase/AfterCombatPriorityWindow/Rotate/Cube)
			
	elif step_data.has("CombatPhaseB"):
		$CombatPhase2.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.CombatPhaseB == "NITPrepareFormation":
			on($CombatPhase2/Attack)
		elif step_data.CombatPhaseB == "NITAttack":
			on($CombatPhase2/Attack)
		elif step_data.CombatPhaseB == "AfterNITAttackPriorityWindow":
			on($CombatPhase2/AfterAttackPriorityWindow/Rotate/Cube)
		elif step_data.CombatPhaseB == "ITBlock":
			on($CombatPhase2/Block)
		elif step_data.CombatPhaseB == "AfterITBlockPriorityWindow":
			on($CombatPhase2/AfterBlockPriorityWindow/Rotate/Cube)
		elif step_data.CombatPhaseB == "Damage":
			on($CombatPhase2/Damage)
		elif step_data.CombatPhaseB == "AfterCombatPriorityWindow":
			on($CombatPhase2/AfterCombatPriorityWindow/Rotate/Cube)
	
	elif step_data.has("MainPhase"):
		$MainPhase.get_active_material(0).albedo_color = Color(Color.YELLOW, 0.5)
		if step_data.MainPhase == "Regroup":
			on($MainPhase/Regroup)
		elif step_data.MainPhase == "ITMain":
			on($MainPhase/ITMain)
		elif step_data.MainPhase == "NITMain":
			on($MainPhase/NITMain)
			
	print(step_data)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
