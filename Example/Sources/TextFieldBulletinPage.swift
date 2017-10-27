/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * An item that displays a textfield.
 *
 * This item demonstrates how to create a bulletin item with a textfield and how it will behave when the keyboard is visible.
 */

class TextFieldBulletinPage: NSObject, BulletinItem {
    var manager: BulletinManager?
    var isDismissable: Bool = true
    var dismissalHandler: ((BulletinItem) -> Void)?
    var nextItem: BulletinItem?

    public let interfaceFactory = BulletinInterfaceFactory()
    public var actionHandler: ((BulletinItem) -> Void)? = nil

    fileprivate var errorLabel: UILabel?
    fileprivate var textField: UITextField?

    func tearDown() {
        errorLabel = nil
        textField = nil
    }

    func makeArrangedSubviews() -> [UIView] {
        var arrangedSubviews = [UIView]()

        let titleLabel = interfaceFactory.makeTitleLabel(reading: "TextField example")
        arrangedSubviews.append(titleLabel)

        errorLabel = interfaceFactory.makeDescriptionLabel(isCompact: true)
        errorLabel!.text = ""
        errorLabel!.textColor = .red
        arrangedSubviews.append(errorLabel!)

        textField = UITextField()
        textField!.delegate = self
        textField!.borderStyle = .roundedRect
        textField!.returnKeyType = .done
        arrangedSubviews.append(textField!)

        // since there isn't a method similar to "viewDidAppear" for BulletinItems,
        // we're using a workaround open the keyboard after a certain amount of time has elapsed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            self?.textField?.becomeFirstResponder()
        }

        return arrangedSubviews
    }
}

extension TextFieldBulletinPage: UITextFieldDelegate {
    func isInputValid(text: String?) -> Bool {
        // some logic here to verify input

        if text != nil && !text!.isEmpty {
            // return true to continue to the next bulletin item
            return true
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isInputValid(text: textField.text) {
            textField.resignFirstResponder()
            actionHandler?(self)
            return true

        } else {
            errorLabel?.text = "You must enter some text to continue."
            textField.backgroundColor = .red
            return false
        }
    }
}
