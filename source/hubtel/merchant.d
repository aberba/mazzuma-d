module hubtel.merchant;

import hubtel.config: Config;

struct MobileMoney
{
	enum TransactionType {send, receive}
	private Config config;

	auto send(string paymentInformation)
	{
		return this.makeTransaction(paymentInformation, TransactionType.send);
	}

	auto receive(string paymentInformation)
	{
		return this.makeTransaction(paymentInformation, TransactionType.receive);
	}

	private auto makeTransaction(string paymentInformation, TransactionType transactionType)
	{
		import std.base64: Base64URL;
		import std.json: JSONValue;
		import std.conv: to;
		import requests: Request, Response;
		string transaction = (transactionType == TransactionType.send) ? "send" : "receive";
		string paymentURL = config.apiURLBase ~ "merchants/" ~ config.merchantAccountNumber ~ "/" ~ transaction ~ "/mobilemoney";
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