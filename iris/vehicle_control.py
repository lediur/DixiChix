###TEMPLATE FOR EDITING FROM FOLLOW_ME.py
import socket
import time
from droneapi.lib import VehicleMode, Location
def arm_and_takeoff(vehicle,api):
    """Dangerous: Arm and takeoff vehicle - use only in simulation"""
    # NEVER DO THIS WITH A REAL VEHICLE - it is turning off all flight safety checks
    # but fine for experimenting in the simulator.
    print "Calibrating"
    api.send_mavlink("calpress")
    time.sleep(10)


    print "Arming and taking off"
    vehicle.mode    = VehicleMode("STABILIZE")
    vehicle.parameters["ARMING_CHECK"] = 0
    vehicle.armed   = True
    vehicle.flush()

    while not vehicle.armed and not api.exit:
        print "Waiting for arming..."
        time.sleep(1)

    print "Taking off!"
    vehicle.commands.takeoff(20) # Take off to 20m height

    # Pretend we have a RC transmitter connected
    rc_channels = vehicle.channel_override
    rc_channels[3] = 1500 # throttle
    vehicle.channel_override = rc_channels

    vehicle.flush()
    time.sleep(10)



def yeild_control():
   
    try:
        # First get an instance of the API endpoint (the connect via web case will be similar)
        api = local_connect()

        # Now get our vehicle (we assume the user is trying to control the virst vehicle attached to the GCS)
        v = api.get_vehicles()[0]

        # Don't let the user try to fly while the board is still booting
        if v.mode.name == "INITIALISING":
            print "Vehicle still booting, try again later"
            return
        arm_and_takeoff(v,api)
        cmds = v.commands
        is_guided = False  # Have we sent at least one destination point?

        # Use the python gps package to access the laptop GPS
        # gpsd = gps.gps(mode=gps.WATCH_ENABLE)

        while not api.exit:
            # This is necessary to read the GPS state from the laptop
            # gpsd.next()

            # if is_guided and v.mode.name != "GUIDED":
            #     print "User has changed flight modes - aborting follow-me"
            #     break

            # Once we have a valid location (see gpsd documentation) we can start moving our vehicle around
            # if (gpsd.valid & gps.LATLON_SET) != 0:
            altitude = 30  # in meters
            # dest = Location(gpsd.fix.latitude, gpsd.fix.longitude, altitude, is_relative=True)
            dest = Location(37.4225, -122.165278, 10, is_relative=True)

            print "Going to: %s" % dest

            # A better implementation would only send new waypoints if the position had changed significantly
            cmds.goto(dest)
            is_guided = True
            v.flush()

            # Send a new target every two seconds
            # For a complete implementation of follow me you'd want adjust this delay
            time.sleep(2)
    except socket.error:
        print "Error: gpsd service does not seem to be running, plug in USB GPS or run run-fake-gps.sh"

yeild_control()
