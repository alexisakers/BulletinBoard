/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import Bulletin

enum BulletinDataSource {

    // MARK: - User Defaults

    static var favoriteTabIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: "HelloPetFavoriteTabIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HelloPetFavoriteTabIndex")
        }
    }

    static var userDidCompleteSetup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "HelloPetUserDidCompleteSetup")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "HelloPetUserDidCompleteSetup")
        }
    }

    // MARK: - Pages

    static func makeIntroPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Welcome to Hello Pet")
        page.image = #imageLiteral(resourceName: "RoundedIcon")

        page.descriptionText = "Discover curated images of the best pets in the world."
        page.actionButtonTitle = "Configure"

        page.isDismissable = false

        page.actionHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    static func makeNotitificationsPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Push Notifications")
        page.image = #imageLiteral(resourceName: "NotificationPrompt")

        page.descriptionText = "Receive push notifications when new photos of pets are available."
        page.actionButtonTitle = "Subscribe"
        page.ignoreButtonTitle = "Not now"

        page.isDismissable = false

        page.actionHandler = { item in
            page.manager?.displayNextItem()
        }

        page.ignoreHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    static func makeLocationPage() -> FeedbackPageBulletinItem {

        let page = FeedbackPageBulletinItem(title: "Customize Feed")
        page.image = #imageLiteral(resourceName: "LocationPrompt")

        page.descriptionText = "We can use your location to customize the feed. This data will be sent to our servers anonymously. You can update your choice later in the app settings."
        page.actionButtonTitle = "Send location data"
        page.ignoreButtonTitle = "No thanks"

        page.isLongDescriptionText = true
        page.isDismissable = false

        page.actionHandler = { item in
            page.manager?.displayNextItem()
        }

        page.ignoreHandler = { item in
            page.manager?.displayNextItem()
        }

        return page

    }

    static func makeCompletionPage() -> PageBulletinItem {

        let page = PageBulletinItem(title: "Setup Completed")
        page.image = #imageLiteral(resourceName: "IntroCompletion")
        page.interfaceFactory.tintColor = #colorLiteral(red: 0.2941176471, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.interfaceFactory.actionButtonTitleColor = .white

        page.descriptionText = "Hello Pet is ready for you to use. Happy browsing!"
        page.actionButtonTitle = "Get started"

        page.isDismissable = true

        page.actionHandler = { item in
            page.manager?.dismissBulletin(animated: true)
            NotificationCenter.default.post(name: .SetupDidComplete, object: item)
        }

        return page

    }

}

// MARK: - Notifications

extension Notification.Name {

    static let FavoriteTabIndexDidChange = Notification.Name("HelloPetFavoriteTabIndexDidChangeNotification")
    static let SetupDidComplete = Notification.Name("HelloPetSetupDidCompleteNotification")

}
