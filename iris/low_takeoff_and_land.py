import time
from droneapi.lib import VehicleMode, Location
from pymavlink import mavutil

api = local_connect()
vehicle = api.get_vehicles()[0]

def arm_and_takeoff(height):
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
        time.sleep(1)

    print "Taking off!"
    vehicle.commands.takeoff(2) # Take off to 2m height

    # Pretend we have a RC transmitter connected
    rc_channels = vehicle.channel_override
    rc_channels[3] = 1500 # throttle
    vehicle.channel_override = rc_channels

    vehicle.flush()
    time.sleep(10)

arm_and_takeoff()
vehicle.commands.land()
vehicle.flush()
time.sleep(1)
vehicle.armed = False
vehicle.flush()