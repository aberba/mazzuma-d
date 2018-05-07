module mazzuma.util;

string getTransactionDirection(in string senderPhoneNumber, in string recipientPhoneNumber)
{
    string senderPrefix = getTransactionDirectionPrefix(senderPhoneNumber);
    string recipientPrefix = getTransactionDirectionPrefix(recipientPhoneNumber);
    return "r" ~ senderPrefix ~ "t" ~ recipientPrefix;
}

string getNetworkName(in string phoneNumber)
{
    import std.conv : to;

    string networkName;
    switch (phoneNumber[0 .. 3])
    {
    case "024":
    case "054":
    case "055":
        networkName = "mtn";
        break;

    case "026":
    case "056":
        networkName = "airtel";
        break;

    case "027":
    case "057":
        networkName = "tigo";
        break;

    case "020":
    case "030":
    case "050":
        networkName = "vodafone";
        break;

    default:
        throw new Exception(
                "Unsuppoted phone number for network detection: " ~ phoneNumber.to!string);
    }

    return networkName;
}

string getTransactionDirectionPrefix(in string phoneNumber)
{
    import std.conv : to;

    // NB: mazzuma doesn't allow vodafone currently
    string directionPiece;
    switch (phoneNumber[0 .. 3])
    {
    case "024":
    case "054":
    case "055":
        directionPiece = "m";
        break;

    case "026":
    case "056":
        directionPiece = "a";
        break;

    case "027":
    case "057":
        directionPiece = "t";

        break;
    case "020":
    case "030":
    case "050":
        directionPiece = "v";

        break;
    default:
        throw new Exception(
                "Unsuppoted phone number for transaction direction: " ~ phoneNumber.to!string);
    }

    return directionPiece;
}
