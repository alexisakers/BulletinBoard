/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * A set of tools to interact with the demo data.
 *
 * This demonstrates how to create and configure bulletin items.
 */

enum BulletinDataSource {

    // MARK: - Pages

    /**
     * Create the introduction page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a description text and
     * and action button.
     *
     * The action button presents the next item (the textfield page).
     */

    static func makeIntroPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Welcome to PetBoard")
        page.image = #imageLiteral(resourceName: "RoundedIcon")
        page.imageAccessibilityLabel = "😻"
        page.appearance = makeLightAppearance()

        page.descriptionText = "Discover curated images of the best pets in the world."
        page.actionButtonTitle = "Configure"

        page.isDismissable = true
        page.shouldStartWithActivityIndicator = true

        page.presentationHandler = { item in

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                item.manager?.hideActivityIndicator()
            }

        }

        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }

        page.nextItem = makeTextFieldPage()

        return page

    }

    /**
     * Create the textfield page.
     *
     * This creates a `TextFieldBulletinPage` with: a title, an error label and a textfield.
     *
     * The keyboard return button presents the next item (the notification page).
     */
    static func makeTextFieldPage() -> TextFieldBulletinPage {

        let page = TextFieldBulletinPage(title: "Enter your Name")
        page.isDismissable = false
        page.descriptionText = "To create your profile, please tell us your name. We will use it to customize your feed."
        page.actionButtonTitle = "Done"

        page.textInputHandler = { (item, text) in

            let datePage = self.makeDatePage(userName: text)
            item.manager?.push(item: datePage)
        }

        return page

    }

    static func makeDatePage(userName: String?) -> BulletinItem {

        var greeting = userName ?? "Lone Ranger"

        if let name = userName {

            let formatter = PersonNameComponentsFormatter()

            if #available(iOS 10.0, *) {
                if let components = formatter.personNameComponents(from: name) {
                    greeting = components.givenName ?? name
                }
            }

        }

        let page = DatePickerBulletinItem(title: "Enter Birth Date")
        page.descriptionText = "When were you born, \(greeting)?"
        page.isDismissable = false
        page.actionButtonTitle = "Done"

        page.actionHandler = { item in
            print(page.datePicker.date)
            item.manager?.displayNextItem()
        }

        page.nextItem = makeNotitificationsPage()

        return page

    }

    /**
     * Create the notifications page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a description text, an action
     * and an alternative button.
     *
     * The action and the alternative buttons present the next item (the location page). The action button
     * starts a notification registration request.
     */

    static func makeNotitificationsPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Push Notifications")
        page.image = #imageLiteral(resourceName: "NotificationPrompt")
        page.imageAccessibilityLabel = "Notifications Icon"

        page.descriptionText = "Receive push notifications when new photos of pets are available."
        page.actionButtonTitle = "Subscribe"
        page.alternativeButtonTitle = "Not now"

        page.isDismissable = false

        page.actionHandler = { item in
            PermissionsManager.shared.requestLocalNotifications()
            item.manager?.displayNextItem()
        }

        page.alternativeHandler = { item in
            item.manager?.displayNextItem()
        }

        page.nextItem = makeLocationPage()

        return page

    }

    /**
     * Create the location page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a compact description text,
     * an action and an alternative button.
     *
     * The action and the alternative buttons present the next item (the animal choice page). The action button
     * requests permission for location.
     */

    static func makeLocationPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Customize Feed")
        page.image = #imageLiteral(resourceName: "LocationPrompt")
        page.imageAccessibilityLabel = "Location Icon"

        page.descriptionText = "We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings."
        page.actionButtonTitle = "Send location data"
        page.alternativeButtonTitle = "No thanks"

        page.appearance.shouldUseCompactDescriptionText = true
        page.isDismissable = false

        page.actionHandler = { item in
            PermissionsManager.shared.requestWhenInUseLocation()
            item.manager?.displayNextItem()
        }

        page.alternativeHandler = { item in
            item.manager?.displayNextItem()
        }

        page.nextItem = makeChoicePage()

        return page

    }

    /**
     * Creates a custom item.
     *
     * The next item is managed by the item itself. See `PetSelectorBulletinPage` for more info.
     */

    static func makeChoicePage() -> PetSelectorBulletinPage {

        let page = PetSelectorBulletinPage(title: "Choose your Favorite")
        page.isDismissable = false
        page.descriptionText = "Your favorite pets will appear when you open the app."
        page.actionButtonTitle = "Select"

        return page

    }

    /**
     * Create the location page.
     *
     * This creates a `PageBulletinItem` with: a title, an image, a description text, and an action
     * button. The item can be dismissed. The tint color of the action button is customized.
     *
     * The action button dismisses the bulletin. The alternative button pops to the root item.
     */

    static func makeCompletionPage() -> PageBulletinItem {

        let page = PageBulletinItem(title: "Setup Completed")
        page.image = #imageLiteral(resourceName: "IntroCompletion")
        page.imageAccessibilityLabel = "Checkmark"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.imageViewTintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.appearance.actionButtonTitleColor = .white

        page.descriptionText = "PetBoard is ready for you to use. Happy browsing!"
        page.actionButtonTitle = "Get started"
        page.alternativeButtonTitle = "Replay"

        page.isDismissable = true

        page.dismissalHandler = { item in
            NotificationCenter.default.post(name: .SetupDidComplete, object: item)
        }

        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }

        page.alternativeHandler = { item in
            item.manager?.popToRootItem()
        }

        return page

    }

    // MARK: - User Defaults

    /// The current favorite tab index.
    static var favoriteTabIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: "PetBoardFavoriteTabIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PetBoardFavoriteTabIndex")
        }
    }

    /// Whether user completed setup.
    static var userDidCompleteSetup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "PetBoardUserDidCompleteSetup")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PetBoardUserDidCompleteSetup")
        }
    }

    /// Whether to use the Avenir font instead of San Francisco.
    static var useAvenirFont: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "UseAvenirFont")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "UseAvenirFont")
        }
    }

}

// MARK: - Appearance

extension BulletinDataSource {

    static func makeLightAppearance() -> BulletinAppearance {

        let appearance = BulletinAppearance()

        if useAvenirFont {

            appearance.titleFontDescriptor = UIFontDescriptor(name: "AvenirNext-Medium", matrix: .identity)
            appearance.descriptionFontDescriptor = UIFontDescriptor(name: "AvenirNext-Regular", matrix: .identity)
            appearance.buttonFontDescriptor = UIFontDescriptor(name: "AvenirNext-DemiBold", matrix: .identity)

        }

        return appearance

    }

    static func currentFontName() -> String {
        return useAvenirFont ? "Avenir Next" : "San Francisco"
    }

}

// MARK: - Notifications

extension Notification.Name {

    /**
     * The favorite tab index did change.
     *
     * The user info dictionary contains the following values:
     *
     * - `"Index"` = an integer with the new favorite tab index.
     */

    static let FavoriteTabIndexDidChange = Notification.Name("PetBoardFavoriteTabIndexDidChangeNotification")

    /**
     * The setup did complete.
     *
     * The user info dictionary is empty.
     */

    static let SetupDidComplete = Notification.Name("PetBoardSetupDidCompleteNotification")

}
