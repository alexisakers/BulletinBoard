/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard
import CustomBulletins

/**
 * A view controller displaying a set of images.
 *
 * This demonstrates how to set up a bulletin manager and present the bulletin.
 */

class ViewController: UIViewController {

    @IBOutlet weak var styleButtonItem: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var showIntoButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    /// The data provider for the collection view.
    private var dataSource: CollectionDataSource!

    /// Whether the status bar should be hidden.
    private var shouldHideStatusBar: Bool = false

    // MARK: - Customization

    /// The available background styles.
    let backgroundStyles = BackgroundStyles()

    /// The current background style.
    var currentBackground = (name: "Dimmed", style: BLTNBackgroundViewStyle.dimmed)

    // MARK: - Bulletin Manager

    /**
     * Configures the bulletin manager.
     *
     * We first need to create the first bulletin item we want to display. Then, we use it to create
     * the bulletin manager.
     */

    lazy var bulletinManager: BLTNItemManager = {
        let introPage = BulletinDataSource.makeIntroPage()
        return BLTNItemManager(rootItem: introPage)
    }()

    // MARK: - View

    override func viewDidLoad() {

        super.viewDidLoad()
        prepareForBulletin()

        // Set up the data

        let favoriteTab = BulletinDataSource.favoriteTabIndex
        segmentedControl.selectedSegmentIndex = favoriteTab
        dataSource = favoriteTab == 0 ? .cat : .dog

        styleButtonItem.title = currentBackground.name

        // Set up the collection view

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self

        let guide = view.readableContentGuide
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true

        collectionView.contentInset.top = 8
        collectionView.contentInset.bottom = 8

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

        // Add toolbar items

        let fontItem = UIBarButtonItem(title: BulletinDataSource.useAvenirFont ? "Avenir" : "San Francisco",
                                       style: .plain,
                                       target: self,
                                       action: #selector(fontButtonItemTapped))

        let statusBarItem = UIBarButtonItem(title: shouldHideStatusBar ? "Status Bar: OFF" : "Status Bar: ON",
                                            style: .plain,
                                            target: self,
                                            action: #selector(fullScreenButtonTapped))

        navigationController?.isToolbarHidden = false
        toolbarItems = [fontItem, statusBarItem]

        // If the user did not complete the setup, present the bulletin automatically

        if !BulletinDataSource.userDidCompleteSetup {
            showBulletin()
        }

    }

    /**
     * Displays the bulletin.
     */

    func showBulletin() {

        reloadManager()

//        Uncomment to customize interface
//        bulletinManager.cardCornerRadius = 22
//        bulletinManager.edgeSpacing = .none
//        bulletinManager.allowsSwipeInteraction = false
//        bulletinManager.hidesHomeIndicator = true
//        bulletinManager.backgroundColor = .blue

        bulletinManager.backgroundViewStyle = currentBackground.style
        bulletinManager.statusBarAppearance = shouldHideStatusBar ? .hidden : .automatic
        bulletinManager.showBulletin(above: self)

    }

    func reloadManager() {
        let introPage = BulletinDataSource.makeIntroPage()
        bulletinManager = BLTNItemManager(rootItem: introPage)
    }

    // MARK: - Actions

    @IBAction func styleButtonTapped(_ sender: Any) {

        let styleSelectorSheet = UIAlertController(title: "Bulletin Background Style",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)

        for backgroundStyle in backgroundStyles {

            let action = UIAlertAction(title: backgroundStyle.name, style: .default) { _ in
                self.styleButtonItem.title = backgroundStyle.name
                self.currentBackground = backgroundStyle
            }

            let isSelected = backgroundStyle.name == currentBackground.name
            action.setValue(isSelected, forKey: "checked")

            styleSelectorSheet.addAction(action)

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        styleSelectorSheet.addAction(cancelAction)

        styleSelectorSheet.popoverPresentationController?.barButtonItem = styleButtonItem
        present(styleSelectorSheet, animated: true)

    }

    @IBAction func showIntroButtonTapped(_ sender: UIBarButtonItem) {
        showBulletin()
    }

    @IBAction func tabIndexChanged(_ sender: UISegmentedControl) {
        updateTab(sender.selectedSegmentIndex)
    }

    @objc func fontButtonItemTapped(sender: UIBarButtonItem) {
        BulletinDataSource.useAvenirFont = !BulletinDataSource.useAvenirFont
        sender.title = BulletinDataSource.currentFontName()
        reloadManager()
    }

    @objc func fullScreenButtonTapped(sender: UIBarButtonItem) {
        shouldHideStatusBar = !shouldHideStatusBar
        sender.title = shouldHideStatusBar ? "Status Bar: OFF" : "Status Bar: ON"
        reloadManager()
    }

    // MARK: - Notifications

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
