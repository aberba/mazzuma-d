module mazzuma.config;

struct Config
{
	string merchantPhoneNumber;
	string apiKey;

	void validate()
	{
		if (this.merchantPhoneNumber == string.init)
			throw new Exception("Merchant phone number is not set in configuration.");

		if (this.apiKey == string.init)
			throw new Exception("API key is not set in configuration.");
	}
}
