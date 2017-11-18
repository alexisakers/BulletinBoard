/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * An item that displays a text field.
 *
 * This item demonstrates how to create a bulletin item with a text field and how it will behave
 * when the keyboard is visible.
 */

class TextFieldBulletinPage: NSObject, BulletinItem {

    var manager: BulletinManager?
    var isDismissable: Bool = false
    var dismissalHandler: ((BulletinItem) -> Void)?
    var nextItem: BulletinItem?

    let interfaceFactory = BulletinInterfaceFactory()
    var actionHandler: ((BulletinItem) -> Void)? = nil

    fileprivate var descriptionLabel: UILabel?
    fileprivate var textField: UITextField?

    func tearDown() {
        descriptionLabel = nil
        textField = nil
    }

    func makeArrangedSubviews() -> [UIView] {
        var arrangedSubviews = [UIView]()

        let titleLabel = interfaceFactory.makeTitleLabel(text: "Enter your Name")
        arrangedSubviews.append(titleLabel)

        descriptionLabel = interfaceFactory.makeDescriptionLabel(isCompact: false)
        descriptionLabel!.text = "We will use it to customize your feed. Press the Done key on your keyboard when you are finished."
        arrangedSubviews.append(descriptionLabel!)

        textField = UITextField()
        textField!.delegate = self
        textField!.borderStyle = .roundedRect
        textField!.returnKeyType = .done
        arrangedSubviews.append(textField!)

        return arrangedSubviews

    }

}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {

    func isInputValid(text: String?) -> Bool {

        if text == nil || text!.isEmpty {
            return false
        }

        return true

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if isInputValid(text: textField.text) {

            textField.resignFirstResponder()
            actionHandler?(self)
            return true

        } else {

            descriptionLabel?.textColor = .red
            descriptionLabel?.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return false

        }

    }

}
