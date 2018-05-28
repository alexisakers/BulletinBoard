# Migrating to _BulletinBoard_ v2

_BulletinBoard_ v2 was released on May 28 2018. This version contains lots of new feature such as extended customizability, and provides a more refined developer experience. To view all the new features, please see the [release notes](https://github.com/alexaubry/BulletinBoard/releases/tag/2.0.0).

Before updating, please be aware that numerous source breaking changes have been made in this version. We wrote this document to help you with the migration task. If you encounter an issue not mentioned in this document, please open an issue on [GitHub](https://github.com/alexaubry/BulletinBoard/issues); we will be happy to help you.

## Imports

For compatibility reasons, the module was renamed to `BLTNBoard`. You will need to update all your import declarations:

### Swift

~~~swift
// import BulletinBoard
import BLTNBoard
~~~

### Objective-C

~~~objc
// #import <BulletinBoard/BulletinBoard.h>
#import <BLTNBoard/BLTNBoard.h>
~~~

## Renamed classes

Most types have been renamed to adopt the `BLTN` prefix. See the table below for a comparison of old and new names.

| Name in <= v1.3.0 | Name in v2.0.0 |
|----------------------|-------------------|
| BulletinItem | BLTNItem |
| BulletinManager | BLTNItemManager |
| PageBulletinItem | BLTNPageItem |
| BulletinPadding | BLTNSpacing |
| BulletinBackgroundViewStyle | BLTNBackgroundViewStyle |
| HighlightButtonWrapper | BLTNHighlightButtonWrapper |

### Changes to interface factory

The `BulletinIterfaceFactory` class was split into two entities: `BLTNItemAppearance` and `BLTNInterfaceBuilder`.

`BLTNActionItem` and its subclasses vend a `BLTNItemAppearance` through their `appearance` property. You can change the values of this object when configuring pages to change the appearance.

When the item calls `makeContentViewsWithInterfaceBuilder`, it creates an iterface builder for subclasses to use when creating the content. If your custom item is not based on `BLTNActionItem`, you can also create a custom `BLTNInterfaceBuilder` yourself.

## Presenting bulletins

You don't need to manually call `prepare` before presenting the bulletin anymore.

Replace:

~~~swift
bulletinManager.prepare()
bulletinManager.presentBulletin(above: self)    
~~~

By:

~~~swift
bulletinManager.showBulletin(above: self)
~~~

## Creating custom items

The flow for creating custom items was revamped. If you create a page that contains buttons and text, you can subclass `BLTNPageItem` and implement one of these methods to provide the views to add:

- `makeHeaderViewsWithInterfaceBuilder:`
- `makeViewsUnderTitleWithInterfaceBuilder:`
- `makeViewsUnderImageWithInterfaceBuilder:`
- `makeViewsUnderDescriptionWithInterfaceBuilder:`
- `makeFooterViewsWithInterfaceBuilder:`

These allow you to create the views you need in addition to the standard controls, without having to recreate those; as it was required in the previous version.

### Example

This is how you would create a page with a text field.

~~~swift
class TextFieldBulletinPage: FeedbackPageBLTNItem {

    var textField: UITextField!

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "First and Last Name", returnKey: .done, delegate: self)
        return [textField]
    }

}

let page = TextFieldBulletinPage(title: "Enter your Name")
page.descriptionText = "This will be displayed on your profile page."
page.actionButtonTitle = "Save"
~~~
