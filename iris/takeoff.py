import time
from droneapi.lib import VehicleMode, Location
from pymavlink import mavutil

api = local_connect()
vehicle = api.get_vehicles()[0]

TAKEOFF_HEIGHT = 5

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

print "Changing to GUIDED mode"
vehicle.mode = VehicleMode("GUIDED")
vehicle.flush()
time.sleep(10)
vehicle.mode = VehicleMode("LAND")
vehicle.flush()