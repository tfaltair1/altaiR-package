Example tool using the WPS/Web Broker Java API.

The application is run from the command line and takes 1 argument - the name of the program to be run on the WPS/Web application server.
The output of this program is then written to standard out. Configuration of the WPS/Web broker is specified in 'config.xml' which must be
in the current working directory when the program is run.

Compile the example using the Ant build tool and run using the following console/terminal commands:

$ ant
$ java -cp ".;..\lib\WPSBroker.jar" org.example.Main <name of program>
