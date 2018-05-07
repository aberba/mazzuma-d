# Mazzuma Mobile Payment API
This is an unofficial [Mazzuma API](https://developers.hubtel.com) for Mobile Money payment written in [D](https://dlang.org). It's also available as a package in the [Dub package registry](https://code.dlang.org/packages/mazzuma).

# Installation
Using Dub, you may add `mazzuma` as dependency in your `dub.json` file and the package will be downloaded automatically during project build if it's not downloaded already.

```json
{
    ...
    "dependencies": {
        "mazzuma": "~>0.0.1"
    }
}
```

You may also fetch the latest version manually in the command-line:

```sh
dub fetch mazzuma
```

# API configuration

The `mazzuma.config.Config` struct is used to configure merchant (receiver) phone number and API key. Substitute information provided below with your own account information. Check the [Mazzuma API Documentation](https://developer.teamcyst.com) for more infomation.

> From a security standpoint, it much safer to store your merhcant account API keys and other confidential information in environment variables instead of hard-coding them in your source code.

```d
import std.stdio : writeln;
import std.conv : to;

import mazzuma : MobileMoney, Config;

void main()
{

    auto config = Config("YOUR_MERCHANT_PHONE_NUMBER", "YOUR_API_KEY");
    MobileMoney pay = MobileMoney(config);

    // Sending payment to your merchant account
    // send(CUSTOMER_PHONE_NUMBER, AMOUNT_CHARGED);
    auto sendResult = pay.send("0247575773", 50.20);
    writeln(sendResult);

    if (sendResult.error)
    {
        //Most likely a network failure
        string errorMessage = sendResult.response;
        writeln("Failed to submit payment: ", sendResult.response);
    }
    else
    {

        //Connection went through. Use response 
        // (JSON string or null) 
        // to determine if payment actually succeeded
        writeln(sendResult.response);

        import std.json : JSONValue;

        auto jsonReponse = JSONValue(sendResult.response);
        writeln("Response as JSON: ", jsonReponse);

        // when a mazzuma errors occures, it returns "null"
        // Currently it's a blackbox with no way of 
        // knowing exactly what happened ATM.
        if (jsonReponse.isNull)
        {
            writeln(
                    "Payment failed, check your balnace or make sure your phone is on approved payment request.");
        }

        // Mazzuma returns {"code":1,"status":"success","id":"XXXXX"} for successful payment
        if (jsonReponse.code.to!int == 1)
            writeln("Payment received ;).");

        // Mazzuma returns {"code":200,"id":"XXXXX","status":"Successful"} for 
        // pending payment i.e. Tigo Cash, you 
        // have to poll continously to get final status
        // using "id" parameter in the JSON response
        // [That sucks, right? ...Yep I know. Mazzuma says 
        // its due to the way Tigo Cash works]
        // Confirm current status at https://developer.teamcyst.com/#usage
        if (jsonReponse.code.to!int == 200)
            writeln(
                    "Payment stattuc pending. Please poll https://client.teamcyst.com/checktransaction.php?id=<id>");
    }
}
```

# Todo
* Add test coverage
    - contract for `send()`
    - API call response
    - `Config()`
* Improve API documentation