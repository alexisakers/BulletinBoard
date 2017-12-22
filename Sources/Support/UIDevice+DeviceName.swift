//
//  UIDevice+DeviceName.swift
//  BulletinBoard
//
//  Created by Cali Castle  on 12/21/17.
//  Copyright © 2017 Bulletin. All rights reserved.
//

import UIKit

extension UIDevice {

    /**
     * Get readable device name.
     *
     * (Simulators will show up as "i386" on a 32-bit and "x86_64" on a 64-bit device)
     * Credits: https://stackoverflow.com/questions/11197509/how-to-get-device-make-and-model-on-ios
     */
    var deviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }

    /// Check if device is iPhone X.
    ///
    /// - Returns: Determine if device is iPhone X

    public func iPhoneX() -> Bool {
        switch deviceName {
        case "iPhone10,3", "iPhone10,6":
            return true
        default:
            break
        }

        return false
    }
}
