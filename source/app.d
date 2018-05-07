import mazzuma : MobileMoney, Config;
import std.stdio : writeln;
import std.conv : to;

void main()
{

    auto config = Config("0207858158", "xxxxxxxxxxxxxxxx");
    MobileMoney pay = MobileMoney(config);

    // Sending payment
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
