# BulletinBoard

[![CI Status](https://travis-ci.org/alexaubry/BulletinBoard.svg?branch=master)](https://travis-ci.org/alexaubry/BulletinBoard)
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

- Xcode 10 and later
- iOS 9 and later
- Swift 4.2 and later

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

Here's a video showing it in action:

[![Watch Demo on YouTube](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_thumbnail.png)](https://youtu.be/f4UErY-epYY)

## Installation

BulletinBoard is available via CocoaPods and Carthage.

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

## 🦕 Objective-C Integration

BulletinBoard is fully compatible with Objective-C.

To import it in your Objective-C app, just add this line at the top of your files:

~~~objc
@import BLTNBoard;
~~~

## Usage

## The Basics

The `BLTNManager` class generates, manages and displays bulletin cards. Cards are created using bulletin items. Bulletin items are objects that conform to the `BLTNItem` protocol.

The library provides a standard item type: `BLTNPageItem`. If you need to customize the items, you can override this class, or create new item types from scratch.

## Displaying Bulletins

To display bulletins you first need to create the root item to display (explained in the next sections).

With this root item, you need to create a `BLTNManager`. We recommend putting it in the view controller that will display the bulletin.

~~~swift
class ViewController: UIViewController {

    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = // ... create your item here
        return BLTNItemManager(rootItem: rootItem)
    }()

}
~~~

To present your bulletin, call this method:

~~~swift
bulletinManager.showBulletin(above: self)
~~~

For the case of onboarding, you can call it in `viewWillAppear(animated:)` after checking if the user has already completed onboarding.

## Creating Page Items

You can create standard page items using the `BLTNPageItem` class.

It takes care of generating a user interface with standard components:

- a title (required)
- an icon image (should be 128x128px or less)
- a description text (plain or attributed)
- a large action button
- a smaller alternative button

For example, this interface was created using a `BLTNPageItem`:

![Customizing BLTNPageItem](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/page_customization.png)

To recreate this interface, use this code:

~~~swift
let page = BLTNPageItem(title: "Push Notifications")
page.image = UIImage(named: "...")

page.descriptionText = "Receive push notifications when new photos of pets are available."
page.actionButtonTitle = "Subscribe"
page.alternativeButtonTitle = "Not now"
~~~

If you omit an optional property, the page won't generate a view for it. For instance, if you set `alternativeButtonTitle` to `nil`, the card won't display an alternative button.

You can also set the `attributedDescriptionText` if you want to use an attributed string.

### Customizing the Appearance

The `BLTNPageItem` class exposes a `appearance` property that allows you to fully customize the appearance of the generated interface.

This property references a `BLTNAppearance`, which is used to generate the standard components (more on this later).

You can customize both color and fonts. You need to change these before you present / push the item. Changing them after presentation will have no effect.

**Example**

~~~swift
let greenColor = UIColor(red: 0.294, green: 0.85, blue: 0.392, alpha: 1)
page.appearance.actionButtonColor = greenColor
page.appearance.alternativeButtonColor = greenColor
page.appearance.actionButtonTitleColor = .white
~~~

This produces a card with the following appearance:

![Demo Tint Color](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_tint_color.png)

### Handling Button Taps

To handle taps on buttons, set a closure for these properties:

- `actionHandler` - called when the action button is tapped.
- `alternativeHandler` - called when the alternative button is tapped.

~~~swift
page.actionHandler = { (item: BLTNActionItem) in
    print("Action button tapped")
}
~~~

This prints `"Action button tapped"` when the action button is tapped.

~~~swift
page.alternativeHandler = { (item: BLTNActionItem) in
    print("Alternative button tapped")
}
~~~

This prints `"Alternative button tapped"` when the alternative button is tapped.

Use these handlers as an opportunity to change the presented item, dismiss the bulletin and/or pass data to your model.

## Changing the Presented Item

The `BLTNItem` protocol exposes a `manager` property that is set when the item is currently being displayed by a manager.

You can use it to interact with the presented bulletin. Call:

- `manager?.popItem()` to go back to the previous item
- `manager?.popToRootItem()` to go back to the first item
- `manager?.push(item:)` with a `BulletinItem` to present a new item
- `manager?.dismissBulletin(animated:)` to dismiss the bulletin
- `manager?.displayNextItem()` to display the next item (see below)

You need to call these methods from the main thread. Never force unwrap `manager`, as this property will be unset as soon as the item is removed from the bulletin.

It is also possible to set the `nextItem` property to the `BLTNItem` that should be displayed next and call the `displayNextItem()` method when you want to display it.

For instance, to present a new card when the user taps the action button:

~~~swift
page.nextItem = makeLocationPage() // Creates a new PageBulletinItem

page.actionHandler = { (item: PageBulletinItem) in
    item.manager?.displayNextItem()
}
~~~

This creates the following interaction:

![Next Item](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_segue.png)

## Displaying an Activity Indicator

If you need to perform a task between the moment the user taps a button and the moment you'll be able to change the presented item, you can call `displayActivityIndicator()` method on the item manager to hide the current card and display an activity indicator.

This is especially useful if you need to fetch data from a server (in-app purchase price, subscription status, ...) or save data (e.g. Core Data).

Once your task is finished, you call one of the methods described in [Changing the Presented Item](#changing-the-presented-item) to display the new item, or call `hideActivityIndicator()` to hide the indicator without changing the item.

**Example**:

~~~swift
page.actionHandler = { (item: BLTNActionItem) in
    item.manager?.displayActivityIndicator()
    // do your task
    // ...
    // when your task is finished, transition to the appropriate bulletin item
    item.manager?.displayNextItem()
}
~~~

This creates the following interaction:

![Activity Indicator](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_activity.png)

## Customizing the Background View

By default, the content behind the card is covered with a semi-opaque view (known as the `.dimming` style).

You can customize the background view by changing the `backgroundViewStyle` property of the manager before calling `prepare()`.

**Example**:

~~~swift
manager.backgroundViewStyle = .blurredExtraLight
manager.showBulletin(above: self)
~~~

Several styles are available in the `BulletinBackgroundViewStyle` enum:

![Dimming View](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_background_styles.png)

> Note: blurred backgrounds are available in iOS 10.0 and later.

## Dismissal

If you set the `isDismissable` property to `true`, the user will be able to dismiss the bulletin by tapping outside of the card or by swiping the card down. This property defaults to `true`. You should set this property to `false` if completing the task is required, and should not be avoided by the user.

By default, a close button will be displayed when the item can be dismissed. If you don't want this behavior, you can set the `requiresCloseButton` property to `false`. This is useful when the bulletin already provides an action button to close the item (such as a “Done“ button).

![Dismissal](https://raw.githubusercontent.com/alexaubry/BulletinBoard/master/.assets/demo_close_button.png)

## Creating Custom Items

To create custom bulletin items, create a class that implements the `BLTNItem` protocol. It is usually easier to subclass `BLTNPageItem` and implement one of the hook methods to provide your custom views to display with standard elements.

See the [Creating a Custom Item](guides/Creating%20a%20Custom%20Item.md) guide to learn more.

## Internals

BulletinBoard uses stack views and Auto Layout to display and manage cards. It automatically adapts to changes in width and height. iPad and iPhone X are supported out of the box.

If you are interested in learning how it works in more details, look at the implementation of `BLTNManager`, `BulletinViewController` and `BLTNInterfaceBuilder`.

## Contributing

Thank you for your interest in the project! Contributions are welcome and appreciated.

Make sure to read these guides before getting started:

- [Code of Conduct](https://github.com/alexaubry/BulletinBoard/blob/master/CODE_OF_CONDUCT.md)
- [Contribution Guidelines](https://github.com/alexaubry/BulletinBoard/blob/master/CONTRIBUTING.md)

## Apps Using _BulletinBoard_

Feel free to submit a PR if you’re using this library in your apps.

- [Babelgum Translator](https://geo.itunes.apple.com/us/app/babelgum-translator/id1412706772?mt=8)
- [Bayes SMS](https://geo.itunes.apple.com/us/app/bayes-sms/id1281197214?mt=12)
- [Fluidics](https://geo.itunes.apple.com/us/app/fluidics/id1330261345?lmt=8)
- [nSuns 5/3/1](https://geo.itunes.apple.com/us/app/nsuns-5-3-1/id1265494052?mt=8)
- [SpdrVision mobile](https://geo.itunes.apple.com/it/app/spdrvision-mobile/id1260166539?mt=8)
- [Views • News Redesigned](https://geo.itunes.apple.com/us/app/views-news-redesigned/id1322754821?ls=1&mt=8)

## Author

Written by Alexis Aubry. You can [find me on Twitter](https://twitter.com/_alexaubry).

## License

BulletinBoard is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
