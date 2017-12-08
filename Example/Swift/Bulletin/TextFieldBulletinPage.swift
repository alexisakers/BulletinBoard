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

class TextFieldBulletinPage: ActionBulletinItem {

    @objc public var textField: UITextField!
    @objc public var descriptionLabel: UILabel!

    @objc public var textInputHandler: ((ActionBulletinItem, String?) -> Void)? = nil

    override init() {

        super.init()

        self.isDismissable = false

    }

    override func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {

        var contentViews = [UIView]()

        let titleLabel = interfaceBuilder.makeTitleLabel(text: "Enter your Name")
        contentViews.append(titleLabel)

        let description = "To create your profile, please tell us your name. We will use it to customize your feed."
        descriptionLabel = interfaceBuilder.makeDescriptionLabel(text: description)
        contentViews.append(descriptionLabel)

        textField = interfaceBuilder.makeTextField(placeholder: "First and Last Name", returnKey: .done, delegate: self)
        contentViews.append(textField)

        let doneButton = interfaceBuilder.makeActionButton(title: "Done")
        doneButton.button.addTarget(self, action: #selector(doneButtonTapped(sender:)), for: .touchUpInside)
        contentViews.append(doneButton)

        return contentViews

    }

    override func tearDown() {
        super.tearDown()
        textField.delegate = nil
    }

}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {

    @objc func doneButtonTapped(sender: UIButton) {
        _ = self.textFieldShouldReturn(self.textField)
    }

    @objc open func isInputValid(text: String?) -> Bool {

        if text == nil || text!.isEmpty {
            return false
        }

        return true

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if isInputValid(text: textField.text) {

            textField.resignFirstResponder()
            textInputHandler?(self, textField.text)
            return true

        } else {

            descriptionLabel.textColor = .red
            descriptionLabel.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return false

        }

    }

}
