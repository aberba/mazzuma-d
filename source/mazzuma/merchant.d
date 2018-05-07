module mazzuma.merchant;

import mazzuma.config : Config;
import mazzuma.util : getTransactionDirection, getNetworkName,
	getTransactionDirectionPrefix;

struct MobileMoney
{

	private Config config;

	public auto send(in string senderPhoneNumber, in double amount)
	{
		import std.json : JSONValue;
		import std.conv : to;
		import requests : Request, Response;

		config.validate();

		string senderNetwork = getNetworkName(senderPhoneNumber);
		string transactionDirection = getTransactionDirection(senderPhoneNumber,
				config.merchantPhoneNumber);

		string data = "{";
		data ~= "'price': '" ~ amount.to!string;
		data ~= "', 'network': '" ~ senderNetwork;
		data ~= "', 'recipient_number': '" ~ config.merchantPhoneNumber;
		data ~= "', 'sender': '" ~ senderPhoneNumber;
		data ~= "', 'option': '" ~ transactionDirection;
		data ~= "', 'apikey': '" ~ config.apiKey;
		data ~= "'}";

		debug
		{
			import std.stdio : writeln;

			writeln("JSON data is: ", data);
		}

		struct Result
		{
			bool error = true;
			string response;
			int code;
		}

		Request req = Request();
		Response res;
		req.addHeaders(["content-type" : "application/json", "Accept" : "application/json"]);

		try
		{
			res = req.post("https://client.teamcyst.com/api_call.php",
					JSONValue(data).toString(), "x-urlformdata-encoded");
			return Result(false, res.responseBody.to!string, res.code);
		}
		catch (Exception e)
		{
			return Result(true, e.msg);
		}
	}
}
