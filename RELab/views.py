from django.http import HttpResponse
from django.shortcuts import render, render_to_response, redirect
import json
import urllib2
import urllib

URL = 'http://192.168.0.140'
RESET_state = "OFF"

def home(request):
	if request.method == 'GET':
		return render(request, 'home.html')
	elif request.method == 'POST':
		print request.REQUEST
		try:
			received_command = request.REQUEST["command"]
			print received_command
			if received_command == "RESET":
				if RESET_state == "OFF":
					received_command = "PUL7=ON"
					RESET_state = "ON"
				else:
					received_command = "PUL7=OFF"
					RESET_state = "OFF"
			query_args = { '': received_command }
			encoded_args = urllib.urlencode(query_args)
			try:
				urllib2.urlopen(URL, encoded_args).read()
			except:
				print "Connection Refused"
			return HttpResponse("POST to Server OK")
		except:
			print "Invalid argument"
			return HttpResponse("POST to Server OK. Invalid argument")		
