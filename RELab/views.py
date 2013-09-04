from django.http import HttpResponse
from django.shortcuts import render, render_to_response, redirect
import json
import urllib2
import urllib

URL = "http://www.google.es"

def home(request):
	if request.method == 'GET':
		return render(request, 'home.html')
	elif request.method == 'POST':
		received_command = request.REQUEST["command"]
		print received_command
		post_data = {command:received_command.encode('utf-8')}
		print type(post_data)
		post_data_encoded = urllib.urlencode(post_data)
		request = urllib2.Request(URL, post_data)
		response = urllib2.urlopen(request)
		the_page = response.read()
		#print response.read()
		return HttpResponse("POST OK")
