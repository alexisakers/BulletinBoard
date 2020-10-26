# BulletinBoard

[![Version](https://img.shields.io/cocoapods/v/BulletinBoard.svg?style=flat)](https://cocoapods.org/pods/BulletinBoard)
[![License](https://img.shields.io/cocoapods/l/BulletinBoard.svg?style=flat)](https://cocoapods.org/pods/BulletinBoard)
[![Platform](https://img.shields.io/cocoapods/p/BulletinBoard.svg?style=flat)](https://cocoapods.org/pods/BulletinBoard)
[![Documentation](https://img.shields.io/badge/Documentation-available-blue.svg)](https://alexaubry.github.io/BulletinBoard)
[![Contact: @_alexaubry](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/twitter_badge.svg?sanitize=true)](https://twitter.com/_alexaubry)

BulletinBoard is an iOS library that generates and manages contextual cards displayed at the bottom of the screen. It is especially well suited for quick user interactions such as onboarding screens or configuration.

It has an interface similar to the cards displayed by iOS for AirPods, Apple TV/HomePod configuration and NFC tag scanning. It supports both the iPhone, iPhone X and the iPad.

It has built-in support for accessibility features such as VoiceOver and Switch Control.

Here are some screenshots showing what you can build with BulletinBoard:

![Demo Screenshots](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_screenshots.png)

## Requirements

- Xcode 11 and later
- iOS 9 and later
- Swift 5.1 and later (also works with Objective-C).

## Demo

A demo project is included in the `BulletinBoard` workspace. It demonstrates how to:

- integrate the library (setup, data flow)
- create standard page cards
- create custom page subclasses to add features
- create custom cards from scratch

Two demo targets are available:

- `BB-Swift` (demo written in Swift)
- `BB-ObjC` (demo written in Objective-C)

Build and run the scheme for your favorite language to open the demo app.

## Installation

### Swift Package Manager

To install BulletinBoard using the [Swift Package Manager](https://swift.org/package-manager/), add this dependency to your `Package.swift` file:

~~~swift
.package(url: "https://github.com/alexaubry/BulletinBoard.git", from: "4.2.0")
~~~

### CocoaPods

To install BulletinBoard using [CocoaPods](https://cocoapods.org), add this line to your `Podfile`:

~~~ruby
pod 'BulletinBoard'
~~~

### Carthage

To install BulletinBoard using [Carthage](https://github.com/Carthage/Carthage), add this line to your `Cartfile`:

~~~
github "alexaubry/BulletinBoard"
~~~

## Documentation

- The full library documentation is available [here](https://alexaubry.github.io/BulletinBoard).
- To learn how to start using `BulletinBoard`, check out our [Getting Started](https://alexaubry.github.io/BulletinBoard/getting-started.html) guide.

## Contributing

Thank you for your interest in the project! Contributions are welcome and appreciated.

Make sure to read these guides before getting started:

- [Code of Conduct](https://github.com/alexaubry/BulletinBoard/blob/master/CODE_OF_CONDUCT.md)
- [Contribution Guidelines](https://github.com/alexaubry/BulletinBoard/blob/master/CONTRIBUTING.md)

## Author

Written by Alexis Aubry. You can [find me on Twitter](https://twitter.com/_alexaubry).

## License

BulletinBoard is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
