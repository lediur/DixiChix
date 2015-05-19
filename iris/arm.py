import time
from droneapi.lib import VehicleMode, Location
from pymavlink import mavutil

api = local_connect()
vehicle = api.get_vehicles()[0]
print "Arming and taking off"
vehicle.mode    = VehicleMode("ALT_HOLD")
vehicle.parameters["ARMING_CHECK"] = 0
vehicle.armed   = True
vehicle.flush()

while not vehicle.armed and not api.exit:
    print "Waiting for arming..."
    vehicle.armed = True
    vehicle.flush()
    time.sleep(1)

print "Armed"