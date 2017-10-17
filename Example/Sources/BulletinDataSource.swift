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
     * The action button presents the next item (the notification page).
     */

    static func makeIntroPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Welcome to Instanimal")
        page.image = #imageLiteral(resourceName: "RoundedIcon")
        page.imageAccessibilityLabel = "😻"

        page.descriptionText = "Discover curated images of the best pets in the world."
        page.actionButtonTitle = "Configure"

        page.isDismissable = true

        page.actionHandler = { item in
            item.displayNextItem()
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
            item.displayNextItem()
        }

        page.alternativeHandler = { item in
            item.displayNextItem()
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

        page.shouldCompactDescriptionText = true
        page.isDismissable = false

        page.actionHandler = { item in
            PermissionsManager.shared.requestWhenInUseLocation()
            item.displayNextItem()
        }

        page.alternativeHandler = { item in
            item.displayNextItem()
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
        return PetSelectorBulletinPage()
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
        page.interfaceFactory.tintColor = #colorLiteral(red: 0.2941176471, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.interfaceFactory.actionButtonTitleColor = .white

        page.descriptionText = "Instanimal is ready for you to use. Happy browsing!"
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
            return UserDefaults.standard.integer(forKey: "HelloPetFavoriteTabIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HelloPetFavoriteTabIndex")
        }
    }

    /// Whether user completed setup.
    static var userDidCompleteSetup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "HelloPetUserDidCompleteSetup")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HelloPetUserDidCompleteSetup")
        }
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

    static let FavoriteTabIndexDidChange = Notification.Name("HelloPetFavoriteTabIndexDidChangeNotification")

    /**
     * The setup did complete.
     *
     * The user info dictionary is empty.
     */

    static let SetupDidComplete = Notification.Name("HelloPetSetupDidCompleteNotification")

}
