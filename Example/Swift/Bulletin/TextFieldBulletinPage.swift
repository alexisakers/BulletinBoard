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

    let appearance = BulletinAppearance()
    var actionHandler: ((BulletinItem) -> Void)? = nil

    fileprivate var descriptionLabel: UILabel?
    fileprivate var textField: UITextField?
    fileprivate var doneButton: HighlightButtonWrapper?

    func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()
        let interfaceBuilder = BulletinInterfaceBuilder(appearance: appearance)

        let titleLabel = interfaceBuilder.makeTitleLabel(text: "Enter your Name")
        arrangedSubviews.append(titleLabel)

        descriptionLabel = interfaceBuilder.makeDescriptionLabel()
        descriptionLabel!.text = "To create your profile, please tell us your name. We will use it to customize your feed."
        arrangedSubviews.append(descriptionLabel!)

        textField = UITextField()
        textField!.delegate = self
        textField!.borderStyle = .roundedRect
        textField!.returnKeyType = .done
        textField!.placeholder = "First and Last Name"
        arrangedSubviews.append(textField!)

        doneButton = interfaceBuilder.makeActionButton(title: "Done")
        doneButton!.button.addTarget(self, action: #selector(doneButtonTapped(sender:)), for: .touchUpInside)
        arrangedSubviews.append(doneButton!)

        return arrangedSubviews

    }

    func tearDown() {
        textField?.delegate = nil
        doneButton?.button.removeTarget(self, action: nil, for: .touchUpInside)
    }

}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {

    @objc func doneButtonTapped(sender: UIButton) {
        _ = textFieldShouldReturn(textField!)
    }

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
