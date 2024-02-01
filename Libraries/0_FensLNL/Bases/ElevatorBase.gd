extends "res://Scenes/SceneBase.gd"

class_name ElevatorBase

var floors = [
	# Examples of floors
	# Button Text, Location, Description
#	["Cellblock", "hall_elevator", "Main level where all the inmate cells are"],
#	["Mineshafts", "mining_elevator", "Lower level where the prison is attached to an asteroid"],
#	["Medical", "med_elevator", "Floor that has all the medical and science facilities"],
]

var flrtorem = []

func _init():
	sceneID = "ElevatorScene"

func getFloor(floor_name):
	for fl in floors:
		if fl[1] == floor_name:
			return fl
	return null

func hasFloor(floor_name):
	return getFloor(floor_name) != null

func getFloors():
	if !(floors.empty()):
		for fl in floors:
			if(fl[1] == GM.pc.location):
				addDisabledButton(fl[0], "You are already here")
			else:
				# Text, Tooltip, gofloor, location
				addButton(fl[0], fl[2], "gofloor", [fl[1]])

func getFloorCount():
	return len(floors)

func addFloor(floor_name, elevator_id, description):
	if not hasFloor(floor_name):
		floors.append([floor_name, elevator_id, description])

func addFloors(new_floors):
	for fl in new_floors:
		addFloor(fl[0], fl[1], fl[2])

func addFloorWithChecks(text: String, tooltip: String, method: String, checks: Array):
	var nchecks = []
	var fchecks = []
	var donce = 0

	for things in checks:		
		if !things is Array:
			nchecks.append(things)
		# Module flag checker
		elif things is Array && len(things) > 3:
			fchecks.append(things)
		# Skill checker
		elif things is Array && len(things) == 3:
			nchecks.append(things)

	var badCheck = ButtonChecks.check(nchecks)
	if (badCheck == null):
		if !(fchecks.empty()):
			for flags in fchecks:
				if getModuleFlag(flags[0], flags[1], flags[2]) == flags[3]:
					donce += 1
				else:
					donce -= 1
			if donce > 0:
				addButton(text, ButtonChecks.getPrefix(nchecks) + tooltip, "gofloor", [method])
				addFloor(text, method, tooltip)
				flrtorem.append([text, method, tooltip])
			elif donce < 0 or donce == 0:
				addDisabledFloor(text, tooltip)
		else:
			addButton(text, ButtonChecks.getPrefix(nchecks) + tooltip, "gofloor", [method])
			addFloor(text, method, tooltip)
			flrtorem.append([text, method, tooltip])
	else:
		var reasonText = ButtonChecks.getReasonText(badCheck)
		if(reasonText != ""):
			reasonText = "["+reasonText+"] "
		addDisabledButton(text, ButtonChecks.getPrefix(nchecks) + reasonText + tooltip)
#	addButtonWithChecks(text,tooltip,method,args,checks)

func addDisabledFloor(text: String, tooltip: String = ""):
	addDisabledButton(text, tooltip)

func addFloorUnlessLate(text: String, tooltip: String = "", arg: String = "", latetext: String = "It's way too late for that"):
	if(GM.main.isVeryLate()):
		addDisabledButton(text, latetext)
	else:
		addButton(text, tooltip, arg)

func removeFloor(floor_name: String):
	for i in range(floors.size()):
		var flr = floors[i]
		if flr[1] == floor_name:
			if flrtorem.find(floor_name) != -1:
				floors.remove(i)
				flrtorem.clear()

# Changes the floor you're currently on
func changeFloor(floor_name):
	var current_floor = GM.pc.location
	var target_floor = getFloor(floor_name)
	if target_floor:
		if current_floor != target_floor[1]:
			processTime(5*60)
			GM.pc.setLocation(target_floor[1])
			aimCamera(target_floor[1])
			removeFloor(target_floor[1])
