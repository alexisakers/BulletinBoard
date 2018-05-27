/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A data provider for a collection view.
 */

enum CollectionDataSource: String {
    case cat, dog

    /// Get the image at the given index.
    func image(at index: Int) -> UIImage {
        let name = "\(rawValue)_img_\(index + 1)"
        return UIImage(named: name)!
    }

    /// The number of images on the data set.
    var numberOfImages: Int {
        return 16
    }

}

// MARK: - ImageCollectionViewCell

/**
 * A collection view cell that displays an image.
 */

class ImageCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        contentView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true

    }

}
