from droneapi.lib import APIException, Vehicle, Attitude, Location, GPSInfo, VehicleMode, Mission, Parameters, Command, CommandSequence
from pymavlink import mavutil

def sendLookAt(vehicle, llh):
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

api = local_connect()
vehicle = api.get_vehicles()[0]
sendLookAt(vehicle,[37.3295494924756, -122.026998214424,100])