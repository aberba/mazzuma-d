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