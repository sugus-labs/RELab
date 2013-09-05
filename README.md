RELab
=====

RELab is a Remote Elevator Laboratory to test control algorithms on logical programmable devices: 
The actual version is 0.1.
To put in production only needs a little configuration in apache httpd.conf.

	sudo nano /etc/apache2/httpd.conf

In this file put this two lines at the start of the file:

	WSGIScriptAlias /RELab/app/ /home/[your user]/[path to RELab]/RELab/wsgi.py
	WSGIPythonPath /home/[your user]/[path to RELab]/

And add this line to the end of that file:

	Alias /RELab/static/ /home/[your user]/[path to RELab]/RELab/static

With that done, like any Django project, put your terminal in the root directory of the project and type:

	$ python manage.py syncdb

After that stay in the same directory and type:

	$ python manage.py runserver 0.0.0.0:8000

You can access to the interface in the same machine on:

	0.0.0.0:8000/RELab

or in another machine (i.e. a mobile device) connected to the same LAN on:

	[MachineLanIP]:8000/RELab
