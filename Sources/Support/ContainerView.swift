/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A view containing a subview, known as the content view.
 *
 * The four edges of the content view are pinned to the container. You can specifiy insets to move the
 * edges of the content view inside the container.
 */

public class ContainerView<V>: UIView where V: UIView {

    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    /// The view inside the container.
    public let contentView: V

    /**
     * Wraps a view inside a container.
     * - parameter view: The subview to use as the content view
     */

    public init(_ view: V) {

        self.contentInset = .zero
        self.contentView = view

        super.init(frame: .zero)
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)

        topConstraint.isActive = true
        bottomConstraint.isActive = true
        leftConstraint.isActive = true
        rightConstraint.isActive = true

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("ContainerView must be initialized with a view using the init(_:) initalizer.")
    }

    // MARK: - Insets

    /// The spacing between the edges of the container and those of the content view.
    public var contentInset: UIEdgeInsets {
        didSet {
            updateInsets()
        }
    }

    private func updateInsets() {

        topConstraint.constant = contentInset.top
        bottomConstraint.constant = -(contentInset.bottom)
        leftConstraint.constant = contentInset.left
        rightConstraint.constant = -(contentInset.right)

    }

}
