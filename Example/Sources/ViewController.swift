/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import Bulletin

/**
 * A view controller displaying a set of images.
 *
 * This demonstrates how to set up a bulletin manager and present the bulletin.
 */

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var showIntoButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Bulletin Manager

    /**
     * Configures the bulletin manager.
     *
     * We first need to create the bulletin items we want to display. Then, we use them to create
     * the bulletin manager.
     */

    lazy var bulletinManager: BulletinManager = {

        let introPage = BulletinDataSource.makeIntroPage()
        let notificationsPage = BulletinDataSource.makeNotitificationsPage()
        let locationPage = BulletinDataSource.makeLocationPage()
        let petSelectorPage = BulletinDataSource.makeChoicePage()
        let completionPage = BulletinDataSource.makeCompletionPage()

        return BulletinManager(items: [introPage, notificationsPage, locationPage, petSelectorPage, completionPage])

    }()

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForBulletin()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Bulletin

    /**
     * Prepares the view controller for the bulletin interface.
     */

    func prepareForBulletin() {

        // Register notification observers

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupDidComplete),
                                               name: .SetupDidComplete,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoriteIndexDidChange(notification:)),
                                               name: .FavoriteTabIndexDidChange,
                                               object: nil)

        // If the user did not complete the setup, present the bulletin automatically

        if !BulletinDataSource.userDidCompleteSetup {
            showBulletin()
        }

    }

    /**
     * Displays the bulletin.
     */

    func showBulletin() {
        bulletinManager.prepare()
        bulletinManager.presentBulletin(above: self)
    }

    // MARK: - Actions

    @IBAction func showIntroButtonTapped(_ sender: UIBarButtonItem) {
        showBulletin()
    }

    @objc func setupDidComplete() {
        BulletinDataSource.userDidCompleteSetup = true
    }

    @objc func favoriteIndexDidChange(notification: Notification) {

        guard let newIndex = notification.userInfo?["Index"] as? Int else {
            return
        }

        segmentedControl.selectedSegmentIndex = newIndex
        BulletinDataSource.favoriteTabIndex = newIndex

    }

}
