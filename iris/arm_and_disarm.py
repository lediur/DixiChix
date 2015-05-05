import time
from droneapi.lib import VehicleMode, Location
from pymavlink import mavutil

api = local_connect()
vehicle = api.get_vehicles()[0]

def arm_and_disarm():
    """Dangerous: Arm and takeoff vehicle - use only in simulation"""
    # NEVER DO THIS WITH A REAL VEHICLE - it is turning off all flight safety checks
    # but fine for experimenting in the simulator.
    print "Arming and taking off"
    vehicle.mode    = VehicleMode("STABILIZE")
    vehicle.parameters["ARMING_CHECK"] = 0
    vehicle.armed   = True
    vehicle.flush()

    while not vehicle.armed and not api.exit:
        print "Waiting for arming..."
        vehicle.armed = True
        vehicle.flush()
        time.sleep(1)
    
    print "Armed"

    # Pretend we have a RC transmitter connected
    rc_channels = vehicle.channel_override
    rc_channels[3] = 1500 # throttle
    vehicle.channel_override = rc_channels
    vehicle.flush()

    print "Taking off! Does it wait for safety button?"
    vehicle.commands.takeoff(2)
    vehicle.flush()
    time.sleep(10)
    # vehicle.send_mavlink(21) # send the command to land, MAV_CMD_NAV_LAND
    vehicle.mode = VehicleMode("LAND")
    vehicle.flush()
    time.sleep(10)

    time.sleep(10)
    vehicle.armed = False
    vehicle.flush()
    print "Disarmed"

arm_and_disarm()