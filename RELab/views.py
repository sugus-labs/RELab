from django.http import HttpResponse
from django.shortcuts import render, render_to_response, redirect
import json

def home(request):
	if request.method == 'GET':
		return render(request, 'home.html')
	elif request.method == 'POST':
		received_command = request.REQUEST["command"]
		print received_command
		return HttpResponse("POST OK")
