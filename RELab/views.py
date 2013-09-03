from django.shortcuts import render, render_to_response, redirect
import json

def home(request):
    return render(request, 'home.html')

