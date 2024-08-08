WPS/Web Java Broker

This API offers a way to use WPS/Web without using CGI-Broker implementation. These Java classes replace the core
functionality of the CGI program and allow:
 - Definition of servers and services
 - Communication with the load manager, including sending information to spawn new servers in a Pool Service
 - Communication with WPS/Web application servers
 - Ability to shutdown the load manager and application servers
All 'view' concerns of the CGI-Broker have been dropped from this API, so no HTML (for example) is generated. This is to
allow flexible usage, whether in a Web environment or a desktop application. 

This distribution package includes:
 - A jar file containing the class files of the API in '/lib/wpsweb_broker_1_0.jar'
 - Example XML configuration files in '/configs'
 - Javadoc for the API in '/doc'
 - An example console application in '/example'
