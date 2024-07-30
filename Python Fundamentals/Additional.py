#!/usr/bin/python3

import requests #Import requests to get requests module commands
import json		#Import json to get json module commands

ip_address = input("Please key in an IP Address:")	#Key in an IP Address

request_url = 'https://geolocation-db.com/jsonp/' + ip_address #Using geolocation as website to lookup
response = requests.get(request_url)		#Using requests to get the url
result = response.content.decode()			#Decode the content
result = result.split("(")[1].strip(")")
result  = json.loads(result)				#Prints the result in dictionary

country_result = result['country_name']		#Get country name
country_code = result['country_code']		#Get country code
latitude_result = result['latitude']		#Get latitude
longitude_result = result['longitude']		#Get Longitude
IPv4 = result['IPv4']						#Get IPv4 Address

print("Country Name:" ,country_result)
print("Country Code:" , country_code)
print("Latitude:" , latitude_result)
print("Longitude:" ,longitude_result)
print("IP Address:" ,IPv4)
