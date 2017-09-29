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

    /// The data provider for the collection view.
    private var dataSource: CollectionDataSource!

    // MARK: - Bulletin Manager

    /**
     * Configures the bulletin manager.
     *
     * We first need to create the first bulletin item we want to display. Then, we use it to create
     * the bulletin manager.
     */

    lazy var bulletinManager: BulletinManager = {
        let introPage = BulletinDataSource.makeIntroPage()
        return BulletinManager(rootItem: introPage)
    }()

    // MARK: - View

    override func viewDidLoad() {

        super.viewDidLoad()
        prepareForBulletin()

        // Set up the data

        let favoriteTab = BulletinDataSource.favoriteTabIndex
        segmentedControl.selectedSegmentIndex = favoriteTab
        dataSource = favoriteTab == 0 ? .cat : .dog

        // Set up the collection view

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self

        let guide = view.readableContentGuide
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true

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

    @IBAction func tabIndexChanged(_ sender: UISegmentedControl) {
        updateTab(sender.selectedSegmentIndex)
    }

    @objc func setupDidComplete() {
        BulletinDataSource.userDidCompleteSetup = true
    }

    @objc func favoriteIndexDidChange(notification: Notification) {

        guard let newIndex = notification.userInfo?["Index"] as? Int else {
            return
        }

        updateTab(newIndex)

    }

    /**
     * Update the selected tab.
     */

    private func updateTab(_ newIndex: Int) {

        segmentedControl.selectedSegmentIndex = newIndex
        dataSource = newIndex == 0 ? .cat : .dog
        BulletinDataSource.favoriteTabIndex = newIndex

        collectionView.reloadData()

    }

}

// MARK: - Collection View

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = dataSource.image(at: indexPath.row)

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let image = dataSource.image(at: indexPath.row)
        let aspectRatio = image.size.height / image.size.width

        let width = collectionView.frame.width
        let height = width * aspectRatio

        return CGSize(width: width, height: height)

    }

}
