<h1 align="center">
  <br>
  <img src="https://i.imgur.com/VPqlydX.png" alt="PurrFinder" width="200"></a>
  <br>
</h1>

# PurrFinder
🐈 Send an alert and find your pet with PurrFinder app.

<img src="https://i.imgur.com/UcR1xG8.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/ZKZiskq.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/rtOsqK8.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/dhPSPjh.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/hMAMAQ9.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/ywfyqUc.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/I82r2eJ.png" width="200" height="450">  

## 🐶 About
The mission of the PurrFinder application is to allow owners to find their lost pet. Users can create an alert if their furry best friend is lost. It will send a notification to users in the area and can contact the owner if they have any information. The application also offers a chat bot to help the owner if he needs information.

## 💻 Requirements
Reciplease is written in Swift 5 and supports iOS 13.0+. Built with Xcode 14.

## 🍀 Architecture
This application is developed according to the [MVVM](https://medium.com/@abhilash.mathur1891/mvvm-in-ios-swift-aa1448a66fb4) architecture.

## 🛠 Dependencies
To authenticate the use and management of accounts I use [Firebase Authentication](https://firebase.google.com/docs/auth?hl=fr). To save and provide data in real time I use [Firestore](https://firebase.google.com/docs/firestore?hl=fr) and [Storage](https://firebase.google.com/docs/storage?hl=fr). To make network calls I use [Alamofire](https://github.com/Alamofire/Alamofire) for an elegant HTTP Networking in Swift.
I use [CocoaPods](https://cocoapods.org) as dependency manager.

## 🕵️ How to test 
### Clone the project

Run `git@https://github.com/yann-rzd/PurrFinder.git`

### Install dependencies

Run `pod install`

### Workspace

Open `PurrFinder.xcworkspace`

### Add your [Open AI](https://platform.openai.com/) API key

Create a file `APIKeys.swift`

Add this code `struct APIKeys {
    static let openAIAPIKey = "yourAPIKey"
}` and replace yourAPIKey with your key. 

Build & Run 🔥
