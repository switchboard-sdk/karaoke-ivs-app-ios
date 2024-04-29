# Karaoke App with Interactive Audio Effects using the Switchboard SDK and Amazon IVS

This repository hosts the source code for a Karaoke App developed using the Switchboard SDK and Amazon Interactive Video Service (IVS). This sample app demonstrates how to create an engaging karaoke experience with live interactive audio effects. The step-by-step guide to building the Android app is detailed in our [blog post](https://community.aws/content/2bjOZXGNZtYebdF5GQvE5Tk1SK2/add-interactive-audio-to-amazon-ivs-live-streams-with-the-switchboard-sdk-karaoke-app-example), this is the iOS equivalent. 


## Important Links

<a href="https://docs.switchboard.audio/" target="_blank">Switchboard SDK</a>

<a href="https://community.aws/content/2bjOZXGNZtYebdF5GQvE5Tk1SK2/add-interactive-audio-to-amazon-ivs-live-streams-with-the-switchboard-sdk-karaoke-app-example" target="_blank">Blog post</a> 

<a href="https://docs.aws.amazon.com/ivs/" target="_blank">Amazon IVS</a>

## Setup

Before opening the project please run:

```
bash scripts/setup.sh
```

This will download the necessary libraries to build the project.

## Create particpant token

Please <a href="https://docs.aws.amazon.com/ivs/latest/RealTimeUserGuide/getting-started-distribute-tokens.html#getting-started-distribute-tokens-console" target="_blank">generate</a> and add your particpant token to `Config.swift`.

## Client ID and Client Secret

To obtain your own clientId and clientSecret for your app, please contact sales@synervoz.com .