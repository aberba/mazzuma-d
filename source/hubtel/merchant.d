module hubtel.merchant;

import hubtel.config: Config;

struct MobileMoney
{
	private Config config;

	auto send(string paymentInformation)
	{
		import std.base64: Base64URL;
		import std.json: JSONValue;
		import std.conv: to;
		import requests: Request, Response;

		string paymentURL = config.apiURLBase ~ "merchants/" ~ config.merchantAccountNumber ~ "/send/mobilemoney";
		string mix = config.clientID ~ ":" ~ config.clientSecret;
		string auth = "Basic " ~ Base64URL.encode(cast(ubyte[]) mix).to!string;

		struct Result
		{
			bool error = false;
			string response;
			int code;
		}

		Request req = Request();
		Response res;
		req.addHeaders([
				"Authorization" : auth,
            	"content-type": "application/json"
			]);

		try
		{
			res = req.post(paymentURL, JSONValue(paymentInformation).toString(), "x-urlformdata-encoded");
			return Result(false, res.responseBody.to!string, res.code);
		}
		catch (Exception e)
		{
			return Result(true, e.msg);
		}
	}

	auto receive(string paymentInformation)
	{
		import std.base64: Base64URL;
		import std.json: JSONValue;
		import std.conv: to;
		import requests: Request, Response;

		string paymentURL = config.apiURLBase ~ "merchants/" ~ config.merchantAccountNumber ~ "/receive/mobilemoney";
		string mix = config.clientID ~ ":" ~ config.clientSecret;
		string auth = "Basic " ~ Base64URL.encode(cast(ubyte[]) mix).to!string;

		struct Result
		{
			bool error = false;
			string response;
			int code;
		}

		Request req = Request();
		Response res;
		req.addHeaders([
				"Authorization" : auth,
            	"content-type": "application/json"
			]);

		try
		{
			res = req.post(paymentURL, JSONValue(paymentInformation).toString(), "x-urlformdata-encoded");
			return Result(false, res.responseBody.to!string, res.code);
		}
		catch (Exception e)
		{
			return Result(true, e.msg);
		}
	}
}