import requests
import json
import urllib3


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


print("\nUsing Redfish to mount an ISO image.") 
print("\nCurrent version assumes no ISO image is attached initially + Server is powered on.")


proxy_url = input("\nEnter your proxy server url, if N/A, please enter none: ")


proxies = {
    "http": proxy_url,
    "https": proxy_url
}


print("\nProxy used: ", proxy_url)


ilo5_ip = input("\nEnter the iLO5 IP address of your server: ")
iso_url = input("\nEnter the url to your ISO image: ")


# Command 1
url = f"https://{ilo5_ip}/redfish/v1/sessionService/Sessions"
headers = {"Content-Type": "application/json"}
data = {"UserName": "Administrator", "Password": "password"}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)


# Command 2
url = f"https://{ilo5_ip}/redfish/v1/sessionService/Sessions"
headers = {"Content-Type": "application/json"}
data = {"UserName": "Administrator", "Password": "password"}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)
token = response.headers.get("X-Auth-Token")


# Command 3
url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2/Actions/VirtualMedia.InsertMedia"
headers = {"Content-Type": "application/json", "X-Auth-Token": token}
data = {"Image": iso_url, "Inserted": True, "WriteProtected": True}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)


# Command 4
url = f"https://{ilo5_ip}/redfish/v1/Managers/1/VirtualMedia/2"
headers = {"Content-Type": "application/json", "X-Auth-Token": token}
data = {"Oem": {"Hpe": {"BootOnNextServerReset": True}}}
response = requests.patch(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)


# Command 5
url = f"https://{ilo5_ip}/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
headers = {"Content-Type": "application/json", "X-Auth-Token": token}
data = {"Action": "Reset", "ResetType": "ForceRestart"}
response = requests.post(url, headers=headers, data=json.dumps(data), proxies=proxies, verify=False)


print("\nISO image mounted successfully, rebooting system now.\n")



