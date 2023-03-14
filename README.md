<h1 align="center">
  <br>
  <img src="https://i.imgur.com/VPqlydX.png" alt="PurrFinder" width="200"></a>
  <br>
</h1>

# Reciplease
🍽 Send an alert and find your pet with PurrFinder app

<img src="https://imgur.com/UcR1xG8" width="200" height="450">&nbsp; &nbsp; <img src="https://imgur.com/ZKZiskq" width="200" height="450">&nbsp; &nbsp; <img src="https://imgur.com/rtOsqK8" width="200" height="450">&nbsp; &nbsp; <img src="https://imgur.com/dhPSPjh" width="200" height="450">&nbsp; &nbsp; <img src="https://imgur.com/ywfyqUc" width="200" height="450">&nbsp; &nbsp; <img src="https://imgur.com/I82r2eJ" width="200" height="450">  

## 🍕 About
Reciplease is the app thats will help you cook nice plats in your everyday life. It will let you enter your ingredients left in your fridge and search for recipes. Recipes that you can save in your app favorite page and have access offline.

## 💻 Requirements
Reciplease is written in Swift 5 and supports iOS 13.0+. Built with Xcode 13.

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
