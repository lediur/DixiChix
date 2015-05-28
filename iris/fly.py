# DroneAPI:
from droneapi.lib import APIException, Vehicle, Attitude, Location, GPSInfo, VehicleMode, Mission, Parameters, Command, CommandSequence
from pymavlink import mavutil

#python
import time
import numpy
import json
import urllib2
import urllib
#raymond
# from get_parse_info import get_location_for_user, get_waypoints_for_user

# from look import lookAt
TAKEOFF_HEIGHT = 15

def get_parse_class_for_username(classname, username):
    params = urllib.urlencode({
        "where": json.dumps({
            "username": username
        })
    })

    url = "https://api.parse.com/1/classes/%s?%s" % (classname, params)

    headers = {
        "X-Parse-Application-Id": "artI8N3mXYFbdiKS1Rl0oMpYgIDQ7YGJJefaevee",
        "X-Parse-REST-API-Key": "jQncZ8630czaRPuz82zqBtm1PtMqdvJeyY4P4yQJ",
        "Content-Type": "application/json"
    }

    request = urllib2.Request(url, None, headers)
    response = urllib2.urlopen(request)

    json_response = json.loads(response.read())
    json_results = json_response["results"]
    return json_results



def get_waypoints_for_user(username):
    json_results = get_parse_class_for_username("FlightPath", username)

    # In case there this user somehow hasn't set any waypoints
    if len(json_results) == 0:
        return []

    waypoint_strings = json_results[len(json_results) - 1]["waypoints"]
    result = []
    for waypoint_string in waypoint_strings:
        lat_long = tuple([float(coord) for coord in waypoint_string.split(" ")])
        result.append(lat_long)

    return result

def lookAt(llh,vehicle):
  msg = vehicle.message_factory.command_long_encode(
                                                  1, 1,    # target system, target component
                                                  mavutil.mavlink.MAV_CMD_DO_SET_ROI, #command
                                                  0, #confirmation
                                                  0, 0, 0, 0, #params 1-4
                                                  llh[0],
                                                  llh[1],
                                                  llh[2]
                                                  )

  vehicle.send_mavlink(msg)

def get_user_loc(vehicle):
	loc = get_waypoints_for_user("ray")[0]
	locList = list(loc)
	locList.append(100)
	lookAt(locList,vehicle)
	return loc

def change_mode(vehicle, mode):
	print "Changing to %s mode" % mode
	vehicle.mode = VehicleMode(mode)
	vehicle.flush()

def get_initial_position(vehicle):
    initial_location = vehicle.location
    startLocation = [initial_location.lat, initial_location.lon, initial_location.alt]
    print "INITIAL LOCATION:", startLocation
    return startLocation

def takeoff(vehicle):
	if not vehicle.armed:
	  change_mode(vehicle, "STABILIZE") #just for arming. why?
	  vehicle.parameters["ARMING_CHECK"] = 0
	  vehicle.flush()
	  while not vehicle.armed:
	    print "Arming..."
	    vehicle.armed = True
	    vehicle.flush()
	    time.sleep(2)

	  change_mode(vehicle, "GUIDED")
	  time.sleep(2)

	  print "Taking off to %s meters" % TAKEOFF_HEIGHT
	  vehicle.commands.takeoff(TAKEOFF_HEIGHT)
	  vehicle.flush()
	  while vehicle.location.alt < TAKEOFF_HEIGHT-1:
	    time.sleep(1)    

def vehicle_at_location(latitude, longitude, vehicle):
	LOCATION_PRECISION = 9.8081598690443722e-07
	if numpy.sqrt((latitude-vehicle.location.lat)**2+(longitude-vehicle.location.lon)**2) < LOCATION_PRECISION:
		return True
	else:
		return False

def user_at_location(latitude, longitude, username,vehicle):
	LOCATION_PRECISION = 0.00000000348367
	user_location = get_user_loc(vehicle)
	# adjust gimbal here
	if user_location is None:
		return false
	if numpy.sqrt((latitude-user_location[0])**2+(longitude-user_location[1])**2) < LOCATION_PRECISION:
		return True
	else:
		return False

def main():
	api = local_connect()
	vehicle = api.get_vehicles()[0]

	TAKEOFF_HEIGHT = 10

	initial_location = get_initial_position(vehicle)
	takeoff(vehicle)
	change_mode(vehicle, "GUIDED")

	waypoints = get_waypoints_for_user("ray") #FIX THIS LATER
	count = 0
	while waypoints:
		count += 1
		current = waypoints.pop(0)
		current = waypoints.pop(0)
		latitude = current[0]
		longitude = current[1]
		current_location = Location(latitude, longitude, TAKEOFF_HEIGHT, is_relative=True)

		print "going to point ", count
		vehicle.commands.goto(current_location)
		vehicle.flush()
		while not vehicle_at_location(latitude, longitude, vehicle): #wait for vehicle to get to waypoint
			time.sleep(1)
		print "vehicle at location"

		while not user_at_location(latitude, longitude, "ray",vehicle):
			time.sleep(1)
		print "user at location"
		time.sleep(5)
		print "slept for 5, going to next point"
		#orient gimbal



main()