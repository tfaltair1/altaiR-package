package org.example;

import com.wpc.web.broker.Broker;
import com.wpc.web.broker.Configuration;
import com.wpc.web.broker.Request;
import com.wpc.web.broker.Response;
import com.wpc.web.broker.Service;
import com.wpc.web.broker.WPSWeb;
import com.wpc.web.broker.XMLConfigurationParser;

import java.io.File;

public class Main {

	public static void main(String[] args) {
		if (args.length < 1) {
			System.out.println("No program name specified");
			return;
		}
		Configuration config = null;
		try {
			config = XMLConfigurationParser.parse(new File("config.xml"));
		} catch (Exception e) {
			System.out.println("Error parsing config.xml: " + e.getMessage());
			return;
		}
		Broker broker = null;
		try {
			broker = WPSWeb.createBroker(config);
		} catch (Exception e) {
			System.out.println("Error with configuration: " + e.getMessage());
			return;
		}
		Response response = null;
		try {
			Service service = broker.getDefaultService();
			if (service == null) {
				System.out.println("No default service specified in the configuration file");
				return;
			}
			Request request = new Request(args[0]);
			System.out.println("Executing " + args[0] + " on " +  service.getName());
			response = service.submitRequest(request);
			StringBuilder builder = new StringBuilder();
			while (true) {
				byte[] buff = new byte[1024];
				int read = response.getInputStream().read(buff, 0, buff.length);
				if (read < 0) {
					break;
				} else {
					builder.append(new String(buff, 0, read, "ISO-8859-1"));
				}
			}
			System.out.println("Response:");
			System.out.println(builder.toString());
		} catch (Exception e) {
			System.out.println("Error when executing request: " + e.getMessage());
		} finally {
			if (response != null) {
				try {
					response.getInputStream().close();
				} catch (Exception e) {
					System.out.println("Error when closing response: " + e.getMessage());
				}
			}
		}
	}

}
