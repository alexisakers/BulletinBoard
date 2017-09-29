/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import Bulletin

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
     * The action button presents the next item in the items stack.
     */

    static func makeIntroPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Welcome to Pugtersest")
        page.image = #imageLiteral(resourceName: "RoundedIcon")

        page.descriptionText = "Discover curated images of the best pets in the world."
        page.actionButtonTitle = "Configure"

        page.isDismissable = false

        page.actionHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    /**
     * Create the notifications page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a description text, an action
     * and an ignore button.
     *
     * The action and the ignore buttons present the next item in the items stack. The action button
     * registers for local notifications.
     */

    static func makeNotitificationsPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Push Notifications")
        page.image = #imageLiteral(resourceName: "NotificationPrompt")

        page.descriptionText = "Receive push notifications when new photos of pets are available."
        page.actionButtonTitle = "Subscribe"
        page.ignoreButtonTitle = "Not now"

        page.isDismissable = false

        page.actionHandler = { item in
            PermissionsManager.shared.requestLocalNotifications()
            page.manager?.displayNextItem()
        }

        page.ignoreHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    /**
     * Create the location page.
     *
     * This creates a `FeedbackPageBulletinItem` with: a title, an image, a compact description text,
     * an action and an ignore button.
     *
     * The action and the ignore buttons present the next item in the items stack. The action button
     * requests permission for location.
     */

    static func makeLocationPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Customize Feed")
        page.image = #imageLiteral(resourceName: "LocationPrompt")

        page.descriptionText = "We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings."
        page.actionButtonTitle = "Send location data"
        page.ignoreButtonTitle = "No thanks"

        page.isLongDescriptionText = true
        page.isDismissable = false

        page.actionHandler = { item in
            PermissionsManager.shared.requestWhenInUseLocation()
            page.manager?.displayNextItem()
        }

        page.ignoreHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    /**
     * Creates a custom item.
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
     * The action and the ignore buttons present the next item in the items stack.
     */

    static func makeCompletionPage() -> PageBulletinItem {

        let page = PageBulletinItem(title: "Setup Completed")
        page.image = #imageLiteral(resourceName: "IntroCompletion")
        page.interfaceFactory.tintColor = #colorLiteral(red: 0.2941176471, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.interfaceFactory.actionButtonTitleColor = .white

        page.descriptionText = "Pugtersest is ready for you to use. Happy browsing!"
        page.actionButtonTitle = "Get started"

        page.isDismissable = true

        page.actionHandler = { item in
            page.manager?.dismissBulletin(animated: true)
            NotificationCenter.default.post(name: .SetupDidComplete, object: item)
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
