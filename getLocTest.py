import get_parse_info as gpi 
import json
import urllib2
import urllib

print "LOCATION", gpi.get_location_for_user("ray")
print "WAYPOINTS", gpi.get_waypoints_for_user("ray")

api = local_connect()
vehicle = api.get_vehicles()[0]

TAKEOFF_HEIGHT = 7

def takeoff():
	if not vehicle.armed:
	  vehicle.mode = VehicleMode("STABILIZE")
	  vehicle.parameters["ARMING_CHECK"] = 0
	  vehicle.flush()
	  while not vehicle.armed:
	    print "Arming..."
	    vehicle.armed = True
	    vehicle.flush()
	    time.sleep(2)

	  print "Changing to GUIDED mode"
	  vehicle.mode = VehicleMode("GUIDED")
	  vehicle.flush()
	  time.sleep(2)

	  print "Taking off to %s meters" % TAKEOFF_HEIGHT
	  vehicle.commands.takeoff(TAKEOFF_HEIGHT)
	  vehicle.flush()
	  while vehicle.location.alt < TAKEOFF_HEIGHT-1:
	    time.sleep(1)

takeoff()
print "Changing to GUIDED mode"
vehicle.mode = VehicleMode("GUIDED")
vehicle.flush()

origin = Location(37.423523, -122.177162, TAKEOFF_HEIGHT, is_relative=True)
print "Going to first point"
vehicle.commands.goto(origin)
vehicle.flush()

time.sleep(20)

next = Location(37.423802, -122.17682, TAKEOFF_HEIGHT, is_relative=True)
print "Going to second point"
vehicle.commands.goto(next)
vehicle.flush()

time.sleep(20)

vehicle.mode = VehicleMode("LAND")
vehicle.flush()