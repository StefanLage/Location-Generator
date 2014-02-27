#!/usr/bin/python

import sys, os, argparse, json, urllib
from datetime import datetime

# Define properties
address = 'Downtown'
city = ''
country = ''
postalCode = ''
path = os.path.dirname(os.path.realpath(__file__))
output = 'gpxFile'
latitude = 0
longitude = 0

# Do the process expected
def main():
	global address
	global city
	global country
	global output
	global path
	global postalCode
	# Get all args
	args = options().parse_args()
	# Set vars
	address = args.address
	city = args.city
	country = args.country
	output = args.output
	path = args.path
	# Directory exists ?
	if os.path.exists(path):
		# Be sure the path is correct
		if(path[-1:] != '/'):
			path = path + '/'
		postalCode = args.postalCode
		# Get coordinate of the location informed
		print('Getting location...')
		coordinates = getCoordinates()
		if coordinates == 1:
			print('Location OK')
			print('Generating GPX...')
			# Generate the file
			generateGPX()
			print('Congrats GPX generated !')
		else:
			print('Location Unknown !')
	else:
		print('Directory does not exists !')

# Adds all options needed
def options():
	parser = argparse.ArgumentParser(description='How to use GPX-Generator')
	parser.add_argument("-a", "--address", type=str, dest="address", help="Address", default=address)
	parser.add_argument("-ci", "--city", type=str, dest="city", help="City", required=True)
	parser.add_argument("-co", "--country", type=str, dest="country", help="Country", required=True)
	parser.add_argument("-o", "--output", type=str, dest="output", help="Output file name", default=output)
	parser.add_argument("-p", "--path", type=str, dest="path", help="Path to save the output file", default=path)
	parser.add_argument("-pc", "--postalcode", type=str, dest="postalCode", help="Postal Code", default='0')
	return parser

# Function to get coordinates in terms of address informed
def getCoordinates():
	global latitude
	global longitude
	url = 'http://maps.google.com/maps/api/geocode/json?address='+address+','+postalCode+','+city+','+country+'&sensor=false'
	request = urllib.urlopen(url)
	data = json.loads(request.read())
	if(data['status'] == 'OK'):
		latitude=data['results'][0]['geometry']['location']['lat']
		longitude=data['results'][0]['geometry']['location']['lng']
		return 1
	return 0;

# Function that will generate the GPX file
def generateGPX():
	content ='<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n\
<gpx\n\
xmlns="http://www.topografix.com/GPX/1/1"\n\
xmlns:gpxx = "http://www.garmin.com/xmlschemas/GpxExtensions/v3"\n\
xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"\n\
xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\n\
http://www.garmin.com/xmlschemas/GpxExtensions/v3\n\
http://www8.garmin.com/xmlschemas/GpxExtensions/v3/GpxExtensionsv3.xsd"\n\
version="1.1"\n\
creator="StefanLage">\n\
	<wpt lat="'+str(latitude)+'" lon="'+str(longitude)+'">\n\
		<time>'+datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")+'</time>\n\
		<name>'+output+'</name>\n\
		<extensions>\n\
			<gpxx:WaypointExtension>\n\
				<gpxx:Address>\n\
					<gpxx:StreetAddress>'+address+'</gpxx:StreetAddress>\n\
					<gpxx:City>'+city+'</gpxx:City>\n\
					<gpxx:Country>'+country[:2].upper()+'</gpxx:Country>\n\
					<gpxx:PostalCode>'+postalCode+'</gpxx:PostalCode>\n\
				</gpxx:Address>\n\
			</gpxx:WaypointExtension>\n\
		</extensions>\n\
	</wpt>\n\
</gpx>'
	# Create the gpx file
	fo = open(path+output+'.gpx', "wb")
	fo.write(content);
	fo.close()

if __name__ == "__main__":
	main()
