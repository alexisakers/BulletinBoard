/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A button to close the bulletin.
 */

class BulletinCloseButton: UIControl {
    private let backgroundContainer = UIView()
    private let closeGlyph = UIImageView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureConstraints()
        configureHighlighting()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
        configureHighlighting()
    }

    private func configureSubviews() {

        // Content

        isAccessibilityElement = true
        accessibilityLabel = Bundle.UIKitCore.localizedString(forKey: "Close", value: "Close", table: nil)
    
        // Layout
        addSubview(backgroundContainer)
        addSubview(closeGlyph)

        backgroundContainer.layer.cornerRadius = 14
        
        closeGlyph.image = UIImage.closeButton.withRenderingMode(.alwaysTemplate)
        closeGlyph.contentMode = .scaleAspectFit
        closeGlyph.clipsToBounds = true

        backgroundContainer.isUserInteractionEnabled = false
        closeGlyph.isUserInteractionEnabled = false

    }

    private func configureConstraints() {

        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        closeGlyph.translatesAutoresizingMaskIntoConstraints = false

        backgroundContainer.widthAnchor.constraint(equalToConstant: 28).isActive = true
        backgroundContainer.heightAnchor.constraint(equalToConstant: 28).isActive = true
        backgroundContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        closeGlyph.widthAnchor.constraint(equalToConstant: 12).isActive = true
        closeGlyph.heightAnchor.constraint(equalToConstant: 12).isActive = true
        closeGlyph.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor).isActive = true
        closeGlyph.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor).isActive = true

    }

    // MARK: - Customization

    func updateColors(isDarkBackground: Bool) {
        if isDarkBackground {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            closeGlyph.tintColor = #colorLiteral(red: 0.3764705882, green: 0.3921568627, blue: 0.431372549, alpha: 1)
        } else {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.3921568627, blue: 0.431372549, alpha: 1)
            closeGlyph.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
    }

    // MARK: - Highlighting

    private func configureHighlighting() {
        addTarget(self, action: #selector(highlight), for: [.touchUpInside, .touchDragEnter])
        addTarget(self, action: #selector(unhighlight), for: [.touchUpInside, .touchDragExit])
    }
    
    @objc private func highlight() {
        let animations = {
            self.alpha = 0.5
        }

        UIView.transition(with: self, duration: 0.1, animations: animations)
    }

    @objc func unhighlight() {
        let animations = {
            self.alpha = 1
        }

        UIView.transition(with: self, duration: 0.1, animations: animations)
    }
}

extension Bundle {
    fileprivate static var UIKitCore: Bundle {
        if #available(iOS 12, *) {
            return Bundle(identifier: "com.apple.UIKitCore")!
        } else {
            return Bundle(for: UIApplication.self)
        }
    }
}

extension UIImage {
    fileprivate static var closeButton: UIImage {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 0.93, y: 30.21))
        shape.addCurve(to: CGPoint(x: 0.97, y: 35.02), controlPoint1: CGPoint(x: -0.28, y: 31.44), controlPoint2: CGPoint(x: -0.35, y: 33.72))
        shape.addCurve(to: CGPoint(x: 5.78, y: 35.06), controlPoint1: CGPoint(x: 2.29, y: 36.34), controlPoint2: CGPoint(x: 4.55, y: 36.3))
        shape.addLine(to: CGPoint(x: 18.01, y: 22.84))
        shape.addLine(to: CGPoint(x: 30.21, y: 35.04))
        shape.addCurve(to: CGPoint(x: 35, y: 34.99), controlPoint1: CGPoint(x: 31.49, y: 36.34), controlPoint2: CGPoint(x: 33.7, y: 36.32))
        shape.addCurve(to: CGPoint(x: 35.05, y: 30.21), controlPoint1: CGPoint(x: 36.33, y: 33.69), controlPoint2: CGPoint(x: 36.33, y: 31.48))
        shape.addLine(to: CGPoint(x: 22.84, y: 18.01))
        shape.addLine(to: CGPoint(x: 35.05, y: 5.79))
        shape.addCurve(to: CGPoint(x: 35, y: 1), controlPoint1: CGPoint(x: 36.33, y: 4.51), controlPoint2: CGPoint(x: 36.33, y: 2.3))
        shape.addCurve(to: CGPoint(x: 30.21, y: 0.95), controlPoint1: CGPoint(x: 33.7, y: -0.32), controlPoint2: CGPoint(x: 31.49, y: -0.32))
        shape.addLine(to: CGPoint(x: 18.01, y: 13.15))
        shape.addLine(to: CGPoint(x: 5.78, y: 0.93))
        shape.addCurve(to: CGPoint(x: 0.97, y: 0.98), controlPoint1: CGPoint(x: 4.55, y: -0.28), controlPoint2: CGPoint(x: 2.27, y: -0.35))
        shape.addCurve(to: CGPoint(x: 0.93, y: 5.79), controlPoint1: CGPoint(x: -0.33, y: 2.3), controlPoint2: CGPoint(x: -0.28, y: 4.55))
        shape.addLine(to: CGPoint(x: 13.15, y: 18.01))
        shape.addLine(to: CGPoint(x: 0.93, y: 30.21))
        shape.close()
        
        let size = CGSize(width: 36, height: 36)
        UIGraphicsBeginImageContext(size)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIColor.black.setFill()
        shape.fill()
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
