/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

class ContinuousMaskView: UIView, RoundedView {

    override class var layerClass: AnyClass {
        return ContinuousMaskLayer.self
    }

}

class RoundedButton: UIButton, RoundedView {

    override class var layerClass: AnyClass {
        return ContinuousMaskLayer.self
    }

}
