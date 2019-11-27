# objectia-swift [![Build Status](https://travis-ci.org/objectia/objectia-swift.svg?branch=master)](https://travis-ci.org/objectia/objectia-swift) 

Swift client for [Objectia API](https://objectia.com)&reg;


## Documentation

See the [Swift API docs](https://docs.objectia.com/swift/).


## Installation

### Swift Package Manager

To integrate using Apple's Swift package manager, add the following as a dependency to your Package.swift:

```swift
.package(url: "https://github.com/objectia/objectia-swift.git", .upToNextMajor(from: "1.0.0"))
```

and then specify "Objectia" as a dependency of the Target in which you wish to use Objectia. Here's an example 

```swift
// swift-tools-version:4.0 
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/objectia/objectia-swift.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: ["Objectia"])
    ]
)
```

Then run <code>swift package update</code> to install or update the dependencies.


### Accio

Accio is a dependency manager based on SwiftPM which can build frameworks for iOS/macOS/tvOS/watchOS. Therefore the integration steps of Objectia are exactly the same as described above. Once your Package.swift file is configured, run <code>accio update</code> instead of <code>swift package update</code>.


### CocoaPods

To use CocoaPods, add the following entry in your Podfile:

```
pod 'Objectia', '~> 1.0'
```

Then run <code>pod install</code>.

In any file you'd like to use Objectia in, don't forget to import the framework with <code>import Objectia</code>.


### Carthage

To use Carthage, make the following entry in your Cartfile:

```
github "objectia/objectia-swift" ~> 1.0
```

Then run <code>carthage update</code>.


### Requirements

* Apple Xcode 10.0 or later with Swift 4.0+


## Usage

The library needs to be configured with your account's API key. Get your own API key by signing up for a free [Objectia account](https://objectia.com).

```swift
import Foundation
import Objectia

guard let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] else {
    print("API key not found...")
    return
}

do {
    try ObjectiaClient.initialize(apiKey: apiKey) 
    let location = try GeoLocation.get(ip: "8.8.8.8")
    print("Country code:", location!.countryCode!)
} catch let err as ObjectiaError {
    print("Request failed:", err) 
} catch {
    print("Other error...") 
}
```


## License and Trademarks

Copyright (c) 2018-19 UAB Salesfly.

Licensed under the [MIT license](https://en.wikipedia.org/wiki/MIT_License). 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Objectia is a registered trademark of [UAB Salesfly](https://www.salesfly.com). 
