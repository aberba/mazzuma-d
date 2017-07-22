# Hubtel Mobile Payment
This is an unofficial [Hubtel Merchant API](https://developers.hubtel.com) for [D](https://dlang.org). It's also available as a package in the [Dub package registry](https://code.dlang.org/packages/hubtel).

# Installation
Using Dub, you may add `hubtel` as dependency in your `dub.json` file and the package will be downloaded automatically during project build if it's not downloaded already.

```json
{
    ...
    "dependencies": {
        "hubtel-d": "~>0.1.0"
    }
}
```

You may also fetch the latest version manually with the command-line using the `dub`:

```sh
dub fetch hubtel
```

# API configuration

The `hubtel.config.Config` struct is used to configure API keys. Substitute information provided below with your own account information. Check the [Hubtel Merhcant API Documentation](https://developers.hubtel.com/documentations/merchant-account-api) for more infomation.

> From a security standpoint, it much safer store your merhcant account API keys and other confidential in environmental variables instead of hard-coding them in your source code. 

```d
import hubtel.config: Config;
import hubtel.merchant: MobileMoney;
import std.stdio: writeln;

string userSendData = 
`
    {
        "RecipientName": "John Doe",
        "RecipientMsisdn": "233264545335",
        "CustomerEmail": "johndoe@gmail.com",
        "Channel": "airtel-gh",
        "Amount": 4.00,
        "PrimaryCallbackUrl": "https://payment.johndoe.com/payment-send-callback" ,
        "SecondaryCallbackUrl": "",
        "Description": "Ordered 2 packages of waakye",
        "ClientReference": "10652132"
    }
`;

string userReceiveData = 
`
    {
        "CustomerName": "Mary Doe",
        "CustomerMsisdn": "233264545335",
        "CustomerEmail": "marydoe@gmail.com",
        "Channel": "airtel-gh",
        "Amount": 7.50,
        "PrimaryCallbackUrl": "https://payment.marydoe.com/payment-receive-callback",
        "Description": "Bowl of Gari"
    } 
`;

void main()
{
    Config config = Config("YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET", "YOUR_MERHCHANT_ACCOUNT_NUMBER");
    MobileMoney pay = MobileMoney(config);

    // Sending payment
    auto sendResult = pay.send(userSendData);
    if (sendResult.error)
    {
        //Take appropriate action here
        string errorMessage = sendResult.response;
    }

    //Connection went through. Use response to determine what happended
    writeln(sendResult.response);


    // Recieving payment
    auto receiveResult = pay.receive(userReceiveData);
     if (receiveResult.error)
    {
        //Take appropriate action here
        string errorMessage = receiveResult.response;
    }

    //Connection went through. Use response to determine what happended
    writeln(receiveResult.response);
}
```

# Todo
* Create data schema payment send and receive
* Improve code test coverage
    - contract for `send()` and receive()`
    - API call response ??
    - `Config()`
* Improve API documentation