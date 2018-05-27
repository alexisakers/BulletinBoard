/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import Foundation

/**
 * A view that contains another view without intrinsic content size.
 *
 * The intrinsic content size is provided by this view, with the `contentSize` property.
 *
 * You should not add subviews directly. Instead, call `setChildView(childView:constraintsBuilder:)`
 * to specify the view that should be displayed and position it with Auto Layout.
 */

@objc public class BLTNContainerView: UIView {

    /// The size of the content displayed in this view.
    @objc public var contentSize: CGSize = .zero

    /**
     * Adds the child view and configures the constraints.
     * - parameter childView: The view to display inside the fixed-size container.
     * - parameter constraintsBuilder: The block of code to executed for adding constaints to position
     * the child view.
     */

    @objc public func setChildView(_ childView: UIView, constraintsBuilder: @escaping (BLTNContainerView, UIView) -> Void) {
        currentChildView?.removeFromSuperview()
        currentChildView = childView
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        constraintsBuilder(self, childView)
    }

    // MARK: - Utilties

    private var currentChildView: UIView?

    public override var intrinsicContentSize: CGSize {
        return contentSize
    }

}


