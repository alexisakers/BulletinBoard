# _BulletinBoard_ Changelog
## Unreleased

## 🔖 v4.1.0
### New Features
- iOS 13 Dark Mode support
[#170](https://github.com/alexaubry/BulletinBoard/issues/170)
- Add mechanism to pop to item
[#165](https://github.com/alexaubry/BulletinBoard/pull/165)

### Fixes
- Remove testing dependencies from the Cartfile 
[#166](https://github.com/alexaubry/BulletinBoard/pull/166)

## 🔖 v4.0.0
### Fixes
- Upgrade to Swift 5

## 🔖 v3.0.0

### New Features

- Add  `isShowingBulletin` property
- Add `willDisplay` method to BLTNItem
- Add option to show the bulletin above the whole application

### Fixes

- Upgrade to Swift 4.2
- Fix frozen dismissal after initial interaction

## 🔖 v2.0.2

- Fix setters and retain semantics
- Add workaround to allow static library usage
- Fix Swift version in Podspec for compatibility with Xcode 10

## 🔖 v2.0.1

- Add missing resources to Podspec (this caused a crash)

## 🔖 v2.0.0

### New Features

- Make PageBulletinItem more open to customization: if you create custom pages, you no longer need to recreate the standard components yourself
- Customize fonts and more colors
- Customize status bar colors
- Customize bulletin background color
- Customize corner radius
- Customize padding between screen and bulletin
- Hide the activity indicator without changing the current item 
- Annotate library to support Objective-C apps
- Handle keyboard frame updates (support for text fields)
- Support for tinting images with template rendering mode
- Allow customization of the background view
- Add text field as a standard control
- Show activity indicator immediately after item is presented
- Callback for configuration and presentation from BulletinItem

### User-Facing Changes

- On iPad, the bulletin will be presented at the center of the screen and can only be dismissed by a tap (no swipe)
- The item will not be dismissed on swipe unless the user lifts their finger from the screen
- Use screen corner radius on iPhone X

### Bug fixes

- Fix dismiss tap background gesture being called for touches inside the content view
- Fix width contraint not being respected for regular layouts
- Fix iTunes Connect rejection bug due to LLVM code coverage
- Fix action button not being hidden when changing the item
- Fix dismissal handler not being called
- Fix controls inside the card not receiving `touchesEnded` events
- Fix cropped bulletin when presenting above split view controller
- Correctly reset non-dismissable cards position when swipe ends
- Fix Auto Layout conflicts during transitions
- Fix crash when reusing bulletin manager

### Library

- Split `BulletinInterfaceFactory` in two more open classes: `BulletinAppearance` for appearance customization, and `BulletinInterfaceBuilder` for interface components creation
- Create `ActionBulletinItem` as a root bulletin item for items with buttons. Handles button creation and tap events. Views above and below buttons are customizable
- Add example of a collection view bulletin item
- Remove `HighlightButton` from public API
- Various gardening operations to make comments and code more clear

## 🔖 v1.3.0

- Add customizable bulletin backgrounds
- Refactor swipe-to-dismiss: use animation controllers
- Add interactive dismissal (animated background blur radius / opacity)
- Improve iPhone X support: display a blurred bar at the bottom of the safe area to highlight the home indicator
- Simplify layout
- Various documentation and codebase improvements

## 🔖 v1.2.0

- Dismiss the bulletin by swiping down
- Support Swift 3.2

## 🔖 v1.1.0

- Add Accessibility technologies support (VoiceOver, Switch Control) - thanks @lennet!
- Add an optional activity indicator before transitions
- Improve memory management and fix retain cycles/leaks

## 🔖 v1.0.0

- Inital Release
