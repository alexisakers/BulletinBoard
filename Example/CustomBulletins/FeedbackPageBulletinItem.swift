/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * A subclass of page bulletin item that plays an haptic feedback when the buttons are pressed.
 *
 * This class demonstrates how to override `PageBLTNItem` to customize button tap handling.
 */

@objc public class FeedbackPageBLTNItem: BLTNPageItem {

    private let feedbackGenerator = SelectionFeedbackGenerator()

    override public func actionButtonTapped(sender: UIButton) {

        // Play an haptic feedback

        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super

        super.actionButtonTapped(sender: sender)

    }

    override public func alternativeButtonTapped(sender: UIButton) {

        // Play an haptic feedback

        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super

        super.alternativeButtonTapped(sender: sender)

    }

}
