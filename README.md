# SearchiTunesMovies
To run this application, you need cocoapods installed in your computer.

A simple demonstration of -
- Using CocoaPods to manage and use open source code libraries
- Using Model View Controller (MVC) pattern
- Networking call to iTunes server using Alamofire (API call)
- Handling response from the server
- Parsing data organized in JSON format
- using computed property variable
- class extention
- Table View Controller with custom cell
- UI search bar delegate
- Auto Layout
- UI Test
- Unit Test

Copyright 2019 Md Khairul Bashar.

Installing cocoapods on your System:
-> Open Terminal:
- sudo gem install cocoapods //Cocoapod is actualy known as Ruby Gem
- pod setup --verbose // You will see the step by step setup, it may take a while

Installing new pods in your iOS project:
-> Open Terminal in your project directory:
- pod init
- open -a Xcode Podfile // open the podfile in Xcode

// The rest of the porcess is applicable for cocoapods version >= 1.1.1
-> Open the podfile in Xcode
- uncomment the plaform : ios ... line
- write the pod names you want in your project under # Pods for [Project name] //ex. pod 'SwiftyJSON'
- save and quit Xcode (also your project)

-> Open Terminal again in your project directory:
- pod install
- Open the newly created project file with .xcworkspace. (You already did close your project prevoiusly)

version check:
-pod --version
