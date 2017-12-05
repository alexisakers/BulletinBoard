/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * An item that displays a choice with two buttons.
 *
 * This item demonstrates how to create a bulletin item with a custom interface, and changing the
 * next item based on user interaction.
 */

class PetSelectorBulletinPage: ActionBulletinItem {

    private var catButtonContainer: UIButton!
    private var dogButtonContainer: UIButton!
    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()

    // MARK: - BulletinItem

    /**
     * Called by the manager when the item is about to be removed from the bulletin.
     *
     * Use this function as an opportunity to do any clean up or remove tap gesture recognizers /
     * button targets from your views to avoid retain cycles.
     */

    override func tearDown() {
        catButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        dogButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    /**
     * Called by the manager to build the view hierachy of the bulletin.
     *
     * We need to return the view in the order we want them displayed. You should use a
     * `BulletinInterfaceFactory` to generate standard views, such as title labels and buttons.
     */

    override func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {

        var contentViews = [UIView]()
        let favoriteTabIndex = BulletinDataSource.favoriteTabIndex

        // Title Label

        let title = "Choose your Favorite"
        let titleLabel = interfaceBuilder.makeTitleLabel(text: title)
        contentViews.append(titleLabel)

        // Description Label

        appearance.shouldUseCompactDescriptionText = false // The text is short, so we don't need to display it with a smaller font
        let descriptionLabel = interfaceBuilder.makeDescriptionLabel()
        descriptionLabel.text = "Your favorite pets will appear when you open the app."
        contentViews.append(descriptionLabel)

        // Pets Stack

        // We add choice cells to a group stack because they need less spacing
        let petsStack = interfaceBuilder.makeGroupStack(spacing: 16)
        contentViews.append(petsStack)

        // Cat Button

        let catButtonContainer = createChoiceCell(emoji: "🐱", title: "Cats", isSelected: favoriteTabIndex == 0)
        catButtonContainer.addTarget(self, action: #selector(catButtonTapped), for: .touchUpInside)
        petsStack.addArrangedSubview(catButtonContainer)

        self.catButtonContainer = catButtonContainer

        // Dog Button

        let dogButtonContainer = createChoiceCell(emoji: "🐶", title: "Dogs", isSelected: favoriteTabIndex == 1)
        dogButtonContainer.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)
        petsStack.addArrangedSubview(dogButtonContainer)

        self.dogButtonContainer = dogButtonContainer

        return contentViews

    }

    // MARK: - Custom Views

    /**
     * Creates a custom choice cell.
     */

    func createChoiceCell(emoji: String, title: String, isSelected: Bool) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(emoji + " " + title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        button.accessibilityLabel = title

        if isSelected {
            button.accessibilityTraits |= UIAccessibilityTraitSelected
        } else {
            button.accessibilityTraits &= ~UIAccessibilityTraitSelected
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
            let nextPage = PetSelectorValidationBulletinPage(animalName: title.lowercased(), animalEmoji: emoji)
            nextPage.actionButtonTitle = "Validate"
            nextPage.alternativeButtonTitle = "Change"
            self.nextItem = nextPage
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
        catButtonContainer?.accessibilityTraits |= UIAccessibilityTraitSelected

        let dogButtonColor = UIColor.lightGray
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits &= ~UIAccessibilityTraitSelected

        // Send a notification to inform observers of the change

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 0])

        // Set the next item

        let nextPage = PetSelectorValidationBulletinPage(animalName: "cats", animalEmoji: "🐱")
        nextPage.actionButtonTitle = "Validate"
        nextPage.alternativeButtonTitle = "Change"

        nextItem = nextPage


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
        catButtonContainer?.accessibilityTraits &= ~UIAccessibilityTraitSelected

        let dogButtonColor = appearance.actionButtonColor
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.setTitleColor(dogButtonColor, for: .normal)
        dogButtonContainer?.accessibilityTraits |= UIAccessibilityTraitSelected

        // Send a notification to inform observers of the change

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 1])

        // Set the next item

        let nextPage = PetSelectorValidationBulletinPage(animalName: "dogs", animalEmoji: "🐶")
        nextPage.actionButtonTitle = "Validate"
        nextPage.alternativeButtonTitle = "Change"

        nextItem = nextPage

    }

    override func actionButtonTapped(sender: UIButton) {

        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Ask the manager to present the next item.
        manager?.displayNextItem()

    }

}

/**
 * A bulletin page that allows the user to validate its selection
 *
 * This item demonstrates popping to the previous item.
 */

class PetSelectorValidationBulletinPage: ActionBulletinItem {

    let animalName: String
    let animalEmoji: String

    init(animalName: String, animalEmoji: String) {
        self.animalName = animalName
        self.animalEmoji = animalEmoji
    }

    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()
    private var successFeedbackGenerator = SuccessFeedbackGenerator()

    // MARK: - BulletinItem

    override func makeContentViews(interfaceBuilder: BulletinInterfaceBuilder) -> [UIView] {

        var contentViews = [UIView]()

        // Title Label

        let title = "Choose your Favorite"
        let titleLabel = interfaceBuilder.makeTitleLabel(text: title)
        contentViews.append(titleLabel)

        // Emoji

        let emojiLabel = UILabel()
        emojiLabel.numberOfLines = 1
        emojiLabel.textAlignment = .center
        emojiLabel.adjustsFontSizeToFitWidth = true
        emojiLabel.font = UIFont.systemFont(ofSize: 66)
        emojiLabel.text = animalEmoji
        emojiLabel.isAccessibilityElement = false

        contentViews.append(emojiLabel)

        // Description Label

        let descriptionLabel = interfaceBuilder.makeDescriptionLabel()
        descriptionLabel.text = "You chose \(animalName) as your favorite animal type. Are you sure?"
        contentViews.append(descriptionLabel)

        return contentViews

    }

    // MARK: - Touch Events

    override func actionButtonTapped(sender: UIButton) {

        // > Play Haptic Feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // > Display the loading indicator

        manager?.displayActivityIndicator()

        // > Wait for a "task" to complete before displaying the next item

        let delay = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delay) {

            // Play success haptic feedback

            self.successFeedbackGenerator.prepare()
            self.successFeedbackGenerator.success()

            // Display next item

            self.nextItem = BulletinDataSource.makeCompletionPage()
            self.manager?.displayNextItem()

        }

    }

    override func alternativeButtonTapped(sender: UIButton) {

        // Play selection haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Display previous item

        manager?.popItem()

    }

}

