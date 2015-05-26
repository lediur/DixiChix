# DroneAPI:
from droneapi.lib import APIException, Vehicle, Attitude, Location, GPSInfo, VehicleMode, Mission, Parameters, Command, CommandSequence
from pymavlink import mavutil

#python
import time

#raymond
from get_parse_info import get_location_for_user, get_waypoints_for_user

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
	LOCATION_PRECISION = 9.8081598690443722e-05
	if numpy.sqrt((latitude-vehicle.location.lat)**2+(longitude-vehicle.location.lon)**2) < LOCATION_PRECISION:
		return True
	else:
		return False

def user_at_location(latitude, longitude, username):
	LOCATION_PRECISION = 0.00034836762192136367
	user_location = get_location_for_user(username)
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
		current_waypoint = waypoints.pop(0)
		latitude = current[0]
		longitude = current[1]
		current_location = Location(latitude, longitude, TAKEOFF_HEIGHT, is_relative=True)

		print "going to point ", count
		vehicle.commands.goto(current_location)
		vehicle.flush()
		while not vehicle_at_location(latitude, longitude, vehicle): #wait for vehicle to get to waypoint
			time.sleep(1)
		print "vehicle at location"

		while not user_at_location(latitude, longitude, "ray"):
			time.sleep(1)
		print "user at location"
		time.sleep(5)
		print "slept for 5, going to next point"
		#orient gimbal



main()