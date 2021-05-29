# This script retrieves TLE data from the Space-Track website using API

import requests
import configparser

# Exception handling
class MyError(Exception):
    def __init___(self,args):
        Exception.__init__(self,"my exception was raised with arguments {0}".format(args))
        self.args = args

# Space-Track URL for TLE retrieval
uriBase                = "https://www.space-track.org"
requestLogin           = "/ajaxauth/login"
requestCmdAction       = "/basicspacedata/query"
requestFindSatellite   = "/class/tle/NORAD_CAT_ID/8820/EPOCH/2015-07-24--2021-02-24/format/tle/orderby/EPOCH/"

# Use configparser package to pull in the ini file (pip install configparser)
config = configparser.ConfigParser()
config.read("./ST_config.ini")
configUsr = config.get("configuration","username")
configPwd = config.get("configuration","password")
siteCred = {'identity': configUsr, 'password': configPwd}


# use requests package to drive the RESTful session with space-track.org
with requests.Session() as session:
    # run the session in a with block to force session to close if we exit

    # need to log in first. note that we get a 200 to say the web site got the data, not that we are logged in
    resp = session.post(uriBase + requestLogin, data = siteCred)
    if resp.status_code != 200:
        raise MyError(resp, "POST fail on login")

    # this query picks up the satellite data from the catalog. Note - a 401 failure shows you have bad credentials
    
    resp = session.get(uriBase + requestCmdAction + requestFindStarlinks)
    if resp.status_code != 200:
        print(resp)
        raise MyError(resp, "GET fail on request for satellite data")

    file = open("LAGEOS1_TLE_6y.txt", "w")
    file.write(resp.text)

    session.close()
print("Completed session")
