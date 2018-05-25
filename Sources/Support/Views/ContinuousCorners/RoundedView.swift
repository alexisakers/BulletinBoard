//
//  RoundedView.swift
//  BLTNBoard
//
//  Created by Alexis AUBRY on 5/25/18.
//  Copyright © 2018 Bulletin. All rights reserved.
//

import UIKit

protocol RoundedView: NSObjectProtocol {
    var layer: CALayer { get }
}

extension RoundedView {

    var cornerRadius: CGFloat {
        get {
            return roundedLayer.continuousCornerRadius
        }
        set {
            roundedLayer.continuousCornerRadius = newValue
        }
    }

    var roundedCorners: UIRectCorner {
        get {
            return roundedLayer.roundedCorners
        }
        set {
            roundedLayer.roundedCorners = newValue
        }
    }

    private var roundedLayer: ContinuousMaskLayer {
        return layer as! ContinuousMaskLayer
    }

}
