# _BulletinBoard_ Changelog

## 🔖 v2.0.0

### Library Structure

- Renamed module to `BLTNBoard` and added `BLTN` prefix to classes
- Add Objective-C support

### New Features

- Make page items more open to customization: if you create custom pages, you no longer need to recreate the standard components yourself
- Customize fonts and more colors
- Customize status bar colors
- Customize bulletin background color
- Customize corner radius
- Customize padding between screen and bulletin
- Hide the activity indicator without changing the current item 
- Handle keyboard frame updates (support for text fields)
- Support for tinting images with template rendering mode
- Allow customization of the background view
- Add text field as a standard control
- Show activity indicator immediately after item is presented
- Callback for presentation and dismissal of items
- Added a close button on the top right corner
- Added a view wrapper for views without intrinsic content size (such as collection views)
- Added possibility to present a view controller above the bulletin (alert, web view, ...)

### User-Facing Changes

- On iPad, the bulletin will be presented at the center of the screen and can only be dismissed by a tap (no swipe)
- The item will not be dismissed on swipe unless the user lifts their finger from the screen
- Use same corner radius as the screen on iPhone X

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
- Sanitize input handling in example text field item (callback was run twice)
- Fixed a `dyld` conflict with Apple private framework

### Library

- Split `BulletinInterfaceFactory` in two more open classes: `BLTNAppearance` for appearance customization, and `BLTNInterfaceBuilder` for interface components creation
- Create `BLTNActionItem` as a root bulletin item for items with buttons. Handles button creation and tap events. Views above and below buttons are customizable
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
