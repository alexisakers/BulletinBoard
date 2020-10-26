/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * An item that displays a choice with two buttons.
 *
 * This item demonstrates how to create a page bulletin item with a custom interface, and changing the
 * next item based on user interaction.
 */

@objc public class PetSelectorBulletinPage: FeedbackPageBLTNItem {
    private var catButtonContainer: UIButton!
    private var dogButtonContainer: UIButton!
    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()
    
    let completionHandler: (BLTNItem) -> Void

    @objc public init(completionHandler: @escaping (BLTNItem) -> Void) {
        self.completionHandler = completionHandler
        super.init(title: "Choose your Favorite")
    }
    
    // MARK: - BLTNItem

    /**
     * Called by the manager when the item is about to be removed from the bulletin.
     *
     * Use this function as an opportunity to do any clean up or remove tap gesture recognizers /
     * button targets from your views to avoid retain cycles.
     */

    public override func tearDown() {
        catButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        dogButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    /**
     * Called by the manager to build the view hierachy of the bulletin.
     *
     * We need to return the view in the order we want them displayed. You should use a
     * `BulletinInterfaceFactory` to generate standard views, such as title labels and buttons.
     */
    
    public override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        let favoriteTabIndex = UserDefaults.standard.favoriteTabIndex

        // Pets Stack

        // We add choice cells to a group stack because they need less spacing
        let petsStack = interfaceBuilder.makeGroupStack(spacing: 16)

        // Cat Button

        let catButtonContainer = createChoiceCell(dataSource: .cat, isSelected: favoriteTabIndex == 0)
        catButtonContainer.addTarget(self, action: #selector(catButtonTapped), for: .touchUpInside)
        petsStack.addArrangedSubview(catButtonContainer)

        self.catButtonContainer = catButtonContainer

        // Dog Button

        let dogButtonContainer = createChoiceCell(dataSource: .dog, isSelected: favoriteTabIndex == 1)
        dogButtonContainer.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)
        petsStack.addArrangedSubview(dogButtonContainer)

        self.dogButtonContainer = dogButtonContainer

        return [petsStack]

    }

    // MARK: - Custom Views

    /**
     * Creates a custom choice cell.
     */

    func createChoiceCell(dataSource: CollectionDataSource, isSelected: Bool) -> UIButton {

        let emoji: String
        let animalType: String

        switch dataSource {
        case .cat:
            emoji = "🐱"
            animalType = "Cats"
        case .dog:
            emoji = "🐶"
            animalType = "Dogs"
        }

        let button = UIButton(type: .system)
        button.setTitle(emoji + " " + animalType, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        button.accessibilityLabel = animalType

        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }

        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2

        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor

        if isSelected {
            next = PetValidationBLTNItem(dataSource: dataSource, animalType: animalType.lowercased(), validationHandler: completionHandler)
        }

        return button

    }

    // MARK: - Touch Events

    /// Called when the cat button is tapped.
    @objc func catButtonTapped() {

        // Play haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI

        let catButtonColor = appearance.actionButtonColor
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.setTitleColor(catButtonColor, for: .normal)
        catButtonContainer?.accessibilityTraits.insert(.selected)

        let dogButtonColor = UIColor.lightGray
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits.remove(.selected)

        // Send a notification to inform observers of the change

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 0])

        // Set the next item

        next = PetValidationBLTNItem(dataSource: .cat, animalType: "cats", validationHandler: completionHandler)
    }

    /// Called when the dog button is tapped.
    @objc func dogButtonTapped() {

        // Play haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI

        let catButtonColor = UIColor.lightGray
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.setTitleColor(catButtonColor, for: .normal)
        catButtonContainer?.accessibilityTraits.remove(.selected)

        let dogButtonColor = appearance.actionButtonColor
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits.insert(.selected)

        // Send a notification to inform observers of the change

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 1])

        // Set the next item
        next = PetValidationBLTNItem(dataSource: .dog, animalType: "dogs", validationHandler: completionHandler)
    }

    override public func actionButtonTapped(sender: UIButton) {
        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Ask the manager to present the next item.
        manager?.displayNextItem()
    }
}
