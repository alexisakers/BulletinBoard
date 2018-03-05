/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

class ContinuousMaskView: UIView {

    var cornerRadius: CGFloat {
        didSet {
            updateMask()
        }
    }

    private let maskLayer: CAShapeLayer

    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.maskLayer = CAShapeLayer()
        super.init(frame: .zero)
        layer.mask = maskLayer
        updateMask()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func updateMask() {
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

}
