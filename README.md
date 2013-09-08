RELab
=====

RELab is a Remote Elevator Laboratory to test control algorithms on logical programmable devices.
 
The actual version is 0.1.

## Requirements ##

RoMIE is developed on a Ubuntu 12.04 system, running:

   * Python 2.7  [Python 2.7 site](http://docs.python.org/2/)
   * Django 1.5.1  [Django site](https://www.djangoproject.com/‎)
   * python-mysqldb 1.2.3  [python_mysqldb site](http://mysql-python.sourceforge.net/MySQLdb.html)
   * mysql-server 5.5.32  [MySQL site](http://www.mysql.com)
   * Supervisord  [Supervisord site](http://http://supervisord.org/)

It might work with other versions.

## Setting up the environment and config ##

To put in production only needs a little configuration in apache httpd.conf.

	$ sudo nano /etc/apache2/httpd.conf

In this file put this two lines at the start of the file:

	WSGIScriptAlias /RELab/app/ /home/[your user]/[path to RELab]/RELab/wsgi.py
	WSGIPythonPath /home/[your user]/[path to RELab]/

And add this line to the end of that file:

	Alias /RELab/static/ /home/[your user]/[path to RELab]/RELab/static

With that done, like any Django project, put your terminal in the root directory of the project and type:

	$ python manage.py syncdb

After that stay in the same directory and type:

	$ python manage.py runserver 0.0.0.0:8008

You can access to the interface in the same machine on:

	0.0.0.0:8008/RELab

or in another machine (i.e. a mobile device) connected to the same LAN on:

	[MachineLanIP]:8008/RELab

*******************************************************************************************

Also you can put in production with a little configuration in apache httpd.conf.

	$ sudo nano /etc/apache2/httpd.conf

In this file put this two lines at the start of the file:

	WSGIScriptAlias /RELab/app/ /home/[your user]/[path to RELab]/RELab/wsgi.py
	WSGIPythonPath /home/[your user]/[path to RELab]/

And add this line to the end of that file:

	Alias /RELab/static/ /home/[your user]/[path to RELab]/RELab/static

you can put your terminal in the root directory of the project and type:

	$ python manage.py syncdb

and put the file supervisord.conf in the path: 

	/etc/supervisord.conf 

and run in a terminal: 

	sudo unlink /tmp/supervisor.sock

	supervisord -c /etc/supervisord.conf

You can access to the interface in the same machine on:

	0.0.0.0:8008/RELab

or in another machine (i.e. a mobile device) connected to the same LAN on:

	[MachineLanIP]:8008/RELab
