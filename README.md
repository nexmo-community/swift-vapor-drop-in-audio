# Swift Client SDK Drop in Audio Chat Server

<img src="https://developer.nexmo.com/assets/images/Vonage_Nexmo.svg" height="48px" alt="Nexmo is now known as Vonage" />

This is a Swift project that uses [Vapor](vapor.codes) to create a HTTP server for the [Vonage Conversation API](https://developer.nexmo.com/conversation/overview). This project was built to be used with an [accompanying app](https://github.com/nexmo-community/swift-client-sdk-drop-in-audio), learn more about both projects on [our blog](LINKICOMING).

A JavaScript version of this server is available on [GitHub](https://github.com/nexmo-community/js-express-drop-in-audio).

## Welcome to Vonage

If you're new to Vonage, you can [sign up for a Vonage API account](https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=swift-vapor-sms) and get some free credit to get you started.

## Prerequisites

+ A Vonage API account.

+ Xcode 12 and Swift 5 or greater.

+ [Vapor 4.0](https://vapor.codes) installed on your machine.

## Running the project

After cloning the project to your machine change into the project directory. Add your `private.key` file to the project directory under `Sources/App/`.

Open it in Xcode by running `vapor xcode` and wait for Xcode to download the packages.

Set a custom working directory for your project. Go to _Product > Scheme > Edit Scheme..._ and set the working directory to the root folder of your project.

Add your Vonage Application ID to `routes.swift`

Once done, build and run (CMD + R) and the server will be accessible on port 8080. 

## Endpoints

The project serves to 3 endpoints:

+ `/auth` (POST): 

This returns a JWT to log the Client SDK in.

Request Body:
```
{
  "name": "value" // String - username
}
```
Request Reponse:
```
{
  "name": "value", // String - username
  "jwt": "value" // String - JWT for the username
}
```
+ `/rooms` (GET):

This returns a list of open chat rooms.

Request Reponse:
```
[
  {
    "id": "value", // String - ID for the room/conversation
    "display_name": "value" // String - Name for the room/conversation
  },
  {
    "id": "value", // String - ID for the room/conversation
    "display_name": "value" // String - Name for the room/conversation
  }
]
```
+ `/rooms` (POST):

This allows the app to create a new room.

Request Body:
```
{
  "display_name": "value" // String - Name for the room/conversation
}
```
Request Reponse:
```
{
  "id": "value" // String - ID for the room/conversation
}
```


## Getting Help

We love to hear from you so if you have questions, comments or find a bug in the project, let us know! You can either:

* Open an issue on this repository
* Tweet at us! We're [@VonageDev on Twitter](https://twitter.com/VonageDev)
* Or [join the Vonage Developer Community Slack](https://developer.nexmo.com/community/slack)

## Further Reading

* Check out the Developer Documentation at <https://developer.nexmo.com>

