import time
from droneapi.lib import VehicleMode, Location, Command
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

cmd = Command(0,0,0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, 
    mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0,-34.364114, 149.166022, 30)
vehicle.commands.add(cmd)