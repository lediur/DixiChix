import json
import urllib2
import urllib

# get_parse_class_for_username
# ============================================================================
# Given a Parse class name and a Parse username, this function gets all the
# objects of that class that belong to the specified user. The list of results
# is returned ordered by date created (the first index holds the first object
# created by that user for that class, and the last index holds the most
# recently created).
#
# Parameters:
# 'classname'   : The String name of the Parse class you are querying for.
# 'username'    : The String name of the Parse user you are querying for.
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

# get_location_for_user
# ============================================================================
# DrivingLocation is the general Parse data class that contains location
# information for all users. This data is uploaded whenever possible from the
# mobile app while the user is driving. This function gets the MOST RECENT
# location that has been uploaded for the specified user.
#
# Parameters:
# 'username'    : The String name of the Parse user you are querying for.
#
# Returns:
# There are two possible cases:
#   1) If there is no location data for the specified user, returns 'None'.
#   2) Otherwise, returns a tuple of floats: (latitude, longitude)
def get_location_for_user(username):
    json_results = get_parse_class_for_username("DrivingLocation", username)

    # In case there this user somehow hasn't uploaded any location data.
    if len(json_results) == 0:
        return None

    driving_location_object = json_results[len(json_results) - 1]
    latitude = driving_location_object["latitude"]
    longitude = driving_location_object["longitude"]

    return (latitude, longitude)

# get_location_for_user
# ============================================================================
# FlightPath is the general Parse data class that contains information about
# waypoints set by all users. This data is uploaded from the mobile app after
# users mark down their wanted waypoints on the Google Maps view. This
# function gets the MOST RECENTLY uploaded waypoints that the specified user
# has set down.
#
# Parameters:
# 'username'    : The String name of the Parse user you are querying for.
#
# Returns:
# There are two possible cases:
#   1) If there is no waypoint data for the wanted user, returns empty list []
#   2) Otherwise, returns a list of tuples of floats of the waypoints...
#      Format: [(lat1, long1), (lat2, long2), ... , (latN, longN)]
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

def main():
    username = "ray"

    # Get most recently uploaded waypoints for the user
    print get_waypoints_for_user(username)

    # Get most recent location information for the user
    location = get_location_for_user(username)
    if (location == None):
        print "We were unable to retrieve location information"
    else:
        print location

main()