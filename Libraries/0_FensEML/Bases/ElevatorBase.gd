extends "res://Scenes/SceneBase.gd"

class_name ElevatorBase

var floors = [
	# Examples of floors
#	["Cellblock", "hall_elevator", "Main level where all the inmate cells are"],
#	["Mineshafts", "mining_elevator", "Lower level where the prison is attached to an asteroid"],
#	["Medical", "med_elevator", "Floor that has all the medical and science facilities"],
]

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
	for fl in floors:
		if(fl[1] == GM.pc.location):
			addDisabledButton(fl[0], "You are already here")
		else:
			# Text, Tooltip, gofloor, location
			addButton(fl[0], fl[2], "gofloor", [fl[1]])
			print(fl[0] + ", " + fl[2] + ", " + "gofloor" + ", " + [fl[1]])
			
func getFloorCount():
	return len(floors)

func addFloor(floor_name, elevator_id, description):
	if not hasFloor(floor_name):
		floors.append([floor_name, elevator_id, description])

func addFloors(new_floors):
	for fl in new_floors:
		addFloor(fl[0], fl[1], fl[2])

func addFloorWithChecks(text: String, tooltip: String, method: String, args, checks: Array):
	var _remarray: Array
	print(args)
	for things in checks:
		if things is Array:
			if (getModuleFlag(things[0],things[1],things[2]) == true):
				print("hello")
			else:
				if(method == GM.pc.location):
					addDisabledButton(text, "You are already here")
				else:
					print(text + ", " +  tooltip + ", " + "gofloor" + ", " + method)
					addButton(text, tooltip, "gofloor", [method])
#		if things is int:
#			if (len(checks) > 3):
#				for i in range(checks.size()):
#					# Check if the element is an array
#					if checks[i] is Array:
#						_remarray = checks[i]
#						# Remove the array element
#						checks.remove(i)
#						print("Array removed at index:", i)
#
#				# Print the updated array
#				print("Updated array:", checks)
#			var badCheck = ButtonChecks.check(checks)
#			if(badCheck == null):
#				addButton(text, ButtonChecks.getPrefix(checks) + tooltip, method, args)
#			else:
#				var reasonText = ButtonChecks.getReasonText(badCheck)
#				if(reasonText != ""):
#					reasonText = "["+reasonText+"] "
#				addDisabledButton(text, ButtonChecks.getPrefix(checks) + reasonText +tooltip)
		
#	print(text,tooltip,method,args,checks)
#		if things.is_type(TYPE_BOOL):
#			
#		elif !things.is_type(TYPE_BOOL):
#			
#func addDisabledFloor(text: String, tooltip: String = ""):
#	addDisabledButton(text, tooltip)
#
#func addFloorUnlessLate(text: String, tooltip: String = "", arg: String = "", latetext: String = "It's way too late for that"):
#	if(GM.main.isVeryLate()):
#		addDisabledButton(text, latetext)
#	else:
#		addButton(text, tooltip, arg)

# Changes the floor you're currently on
func changeFloor(floor_name):
	var current_floor = GM.pc.location
	var target_floor = getFloor(floor_name)
	if target_floor:
		if current_floor != target_floor[1]:
			print(current_floor + ", " + target_floor[1])
			processTime(5*60)
			GM.pc.setLocation(target_floor[1])
			aimCamera(target_floor[1])
		print(current_floor + ", " + target_floor[1])
