/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * A bulletin page that allows the user to validate its selection.
 *
 * This item demonstrates popping to the previous item, and including a collection view inside the page.
 */

@objc public class PetValidationBLTNItem: FeedbackPageBLTNItem {

    let dataSource: CollectionDataSource
    let animalType: String
    let validationHandler: (BLTNItem) -> Void

    let selectionFeedbackGenerator = SelectionFeedbackGenerator()
    let successFeedbackGenerator = SuccessFeedbackGenerator()

    init(dataSource: CollectionDataSource, animalType: String, validationHandler: @escaping (BLTNItem) -> Void) {
        self.dataSource = dataSource
        self.animalType = animalType
        self.validationHandler = validationHandler
        super.init(title: "Choose your Favorite")

        isDismissable = false
        descriptionText = "You chose \(animalType) as your favorite animal type. Here are a few examples of posts in this category."
        actionButtonTitle = "Validate"
        alternativeButtonTitle = "Change"

    }

    // MARK: - Interface

    var collectionView: UICollectionView?

    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white

        let collectionWrapper = interfaceBuilder.wrapView(collectionView, width: nil, height: 256, position: .pinnedToEdges)

        self.collectionView = collectionView
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self

        return [collectionWrapper]

    }

    override public func tearDown() {
        super.tearDown()
        collectionView?.dataSource = nil
        collectionView?.delegate = nil
    }

    // MARK: - Touch Events

    override public func actionButtonTapped(sender: UIButton) {

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
            self.validationHandler(self)
        }
    }

    public override func alternativeButtonTapped(sender: UIButton) {

        // Play selection haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Display previous item

        manager?.popItem()

    }

}

// MARK: - Collection View

extension PetValidationBLTNItem: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = dataSource.image(at: indexPath.row)
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true

        return cell

    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let squareSideLength = (collectionView.frame.width / 3) - 3
        return CGSize(width: squareSideLength, height: squareSideLength)

    }

}
