module hubtel.config;

struct Config
{
	string clientID;
	string clientSecret;
	string merchantAccountNumber;
	string apiURLBase = "https://api.hubtel.com/v1/merchantaccount/";
}