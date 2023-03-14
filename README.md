<h1 align="center">
  <br>
  <img src="https://i.imgur.com/VPqlydX.png" alt="PurrFinder" width="200"></a>
  <br>
</h1>

# PurrFinder
🐈 Send an alert and find your pet with PurrFinder app.

<img src="https://i.imgur.com/UcR1xG8.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/ZKZiskq.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/rtOsqK8.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/dhPSPjh.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/ywfyqUc.png" width="200" height="450">&nbsp; &nbsp; <img src="https://i.imgur.com/I82r2eJ.png" width="200" height="450">  

## 🐶 About
The mission of the PurrFinder application is to allow owners to find their lost pet. Users can create an alert if their furry best friend is lost. It will send a notification to users in the area and can contact the owner if they have any information. The application also offers a chat bot to help the owner if he needs information.

## 💻 Requirements
Reciplease is written in Swift 5 and supports iOS 13.0+. Built with Xcode 14.

## 🍀 Architecture
This application is developed according to the [MVC](https://medium.com/@joespinelli_6190/mvc-model-view-controller-ef878e2fd6f5) architecture.

## 🛠 Dependencies
To save recipe for offline use [CoreData](https://developer.apple.com/documentation/coredata) and [Alamofire](https://github.com/Alamofire/Alamofire) for an elegant HTTP Networking in Swift.
I use [CocoaPods](https://cocoapods.org) as dependency manager.

## 🕵️ How to test 
### Clone the project

Run `git@github.com:github.com/yann-rzd/Reciplease.git`

### Install dependencies

Run `pod install`

### Workspace

Open `Reciplease.xcworkspace`

### Add your [Edamam](https://www.edamam.com/) API key

Create a file `APIKeys.swift`

Add this code `struct APIKeys {
    static let recipeKey = "yourAPIKey"
}` and replace yourAPIKey with your key. 

Build & Run 🔥
