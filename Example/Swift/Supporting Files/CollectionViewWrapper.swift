/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

class CollectionViewWrapper: UIView {

    let collectionView: UICollectionView

    // change this value to the height you want for your collection view
    var pageHeight: CGFloat = 256

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(frame: .zero)

        // pin the collection view to the edges of the wrapper
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // allow the collection view to be resized to fit the width of the bulletin
        setContentHuggingPriority(.defaultLow, for: .horizontal)

        // do not allow the collection view to be resized vertically
        setContentCompressionResistancePriority(.required, for: .vertical)

    }

    @available(*, unavailable, message: "Use init(collectionView:)")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(collectionView:)")
    }

    override var intrinsicContentSize: CGSize {
        // use 0 to have a flexible width, and use the fixed height
        return CGSize(width: 0, height: pageHeight)
    }

}
