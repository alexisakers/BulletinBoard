/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import Bulletin

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var showIntoButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Bulletin Manager

    lazy var bulletinManager: BulletinManager = {

        let introPage = BulletinDataSource.makeIntroPage()
        let notificationsPage = BulletinDataSource.makeNotitificationsPage()
        let locationPage = BulletinDataSource.makeLocationPage()
        let petSelectorPage = PetSelectorBulletinPage()
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

    func prepareForBulletin() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupDidComplete),
                                               name: .SetupDidComplete,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoriteIndexDidChange(notification:)),
                                               name: .FavoriteTabIndexDidChange,
                                               object: nil)

        if !BulletinDataSource.userDidCompleteSetup {
            showBulletin()
        }

    }

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
