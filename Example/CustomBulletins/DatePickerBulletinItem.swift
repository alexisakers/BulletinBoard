/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * A bulletin item that demonstrates how to integrate a date picker inside a bulletin item.
 */

@objc public class DatePickerBLTNItem: BLTNPageItem {
    public lazy var datePicker = UIDatePicker()

    /**
     * Display the date picker under the description label.
     */
    
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        datePicker.datePickerMode = .date
        return [datePicker]
    }
}
