# 🔖 Migration

This guide provides details for how to migrate between major versions of _BulletinBoard_.

## From 1.x to 2.x

> **NOTE**: This release contains lots of improvements and source breaking changes.

### Presenting the next item

The `displayNextItem` method must be called from a bulletin manager, and not from the item directly.

> 1.x

~~~swift
page.actionHandler = { item in
    item.displayNextItem()
}
~~~

> 2.x

~~~swift
page.actionHandler = { item in
    item.manager?.displayNextItem()
}
~~~

Please note that this method now traps if the `nextItem` property is not set.

### `ContainerView` class removed

This class was primirarly used for highlight button wrappers.

If you were using this undocumented class for your custom items and need help to migrate, you can open an issue. 

#### Declaring the button

> 1.x

~~~swift
fileprivate var actionButton: ContainerView<HighlightButton>? = nil
~~~

> 2.x

~~~swift
fileprivate var actionButton: HighlightButtonWrapper? = nil
~~~

#### Accessing the button

> 1.x

~~~swift
let actionButton = interfaceFactory.makeActionButton(title: actionButtonTitle)

actionButton.contentView.addTarget()
~~~

> 2.x

~~~swift
let actionButton = interfaceFactory.makeActionButton(title: actionButtonTitle)

actionButton.button.addTarget()
~~~

### `BulletinInterfaceFactory` class removed

The `BulletinInterfaceFactory` class was split into two new classes: `BulletinAppearance` and `BulletinInterfaceBuilder`.

- `BulletinAppearance` is used to customize the appearance of the item
- `BulletinInterfaceBuilder` is used to create the views

#### Creating standard interface components

> 1.x

~~~swift
let interfaceFactory = BulletinInterfaceFactory()

func makeArrangedSubviews() -> [UIView] {
    let titleLabel = interfaceFactory.makeTitleLabel(reading: "Title")
}
~~~

> 2.x

~~~swift
let appearance = BulletinAppearance()

func makeArrangedSubviews() -> [UIView] {

    let interfaceBuilder = BulletinInterfaceBuilder(appearance: appearance)

    let titleLabel = interfaceFactory.makeTitleLabel()
    titleLabel.text = "Title"

}
~~~

#### Customizing the appearance

> 1.x

~~~swift
interfaceFactory.tintColor = .green
~~~

> 2.x 

~~~swift
interfaceBuilder.actionButtonColor = .green
interfaceBuilder.alternativeButtonColor = .green
~~~

More customization options are available for fonts and colors (see the documentation for `BulletinAppearance`).

### Creating custom items

If you were creating `BulletinItem`s from scratch, we recommand that you use the new subclassing features to create items (see guide).

> **NOTE**: `actionHandler` and `alternativeHandler` provide an instance of `ActionBulletinItem`, and no longer a `PageBulletinItem`.