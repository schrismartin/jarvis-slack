# 🎩 Jarvis
Jarvis is a bot made with the intention of providing additonal functionality to Slack. 

## 📖 Documentation

You can check out the documentation for this project by visiting [here](http://schrismart.in/jarvis-slack).

## 📱 Usage

Currently, the bot will respond to the following commands: 

* `jarvis echo [message]` – Jarvis will respond to the group with "Echo: [message]".
* `jarvis info messages` – Jarvis will tell how many messages the group has sent
* `jarvis info members` – Jarvis will tell about how many people are in the group.
* `jarvis info age` – Jarvis will respond with the created date of the group.

/jarvis {command} {arguments}
   • `jarvis echo [message]` – _Echo your message back to you._
   • `jarvis compliment @user` –  _Create a compliment for yourself, or direct it at the specified user._
   • `jarvis burn @user` –  _Insult yourself, or direct it at the specified user._
   • `jarvis inspire` –  _Create an AI-generated inspirational poster!_
   • `jarvis identify` –  _Returns information on the sender_
   • `jarvis upvotes @user` –  _Shows you the number of upvotes you currently have._
   • `jarvis ping` –  _Pings the server to ensure it's active._
   • `jarvis gelp` –  _Get help on how to use Jarvis_

More commands are being added occasionally. Check back for an updated list. 

## 🔧 Building

Jarvis should be built and run using the [Vapor CLI](https://docs.vapor.codes/3.0/getting-started/toolbox/).

```shell
$ vapor run
```

Generating an xcode project is relatively simple using the Vapor CLI as well.

```shell
$ vapor xcode
```

This will generate an xcode project with the necessary targets set up. To run, just build and run the `Run` target.

## 💻 Environment Variables
You will need to set up the following environment variables in order to get full functionality of the project:

##### General
- `DATABASE_URL`: This will need to point to a postgress database used to cache event and user data.

##### Slack
- `BOT_TOKEN`: This is the token for the bot in the Slack app
- `SLACK_TOKEN`: This is an additional token used to authorize the bot with Slack.

##### Sentiment Analysis
Jarvis makes use of the [AYLIEN](https://docs.aylien.com) Text Analysis API to perform sentiment analysis on user messages. If you wish to use this feature, you will need need the following keys:
- `SENTIMENT_APP_ID`: The id for the account linked to use the API
- `SENTIMENT_API_KEY`: The API key to authorize requests
