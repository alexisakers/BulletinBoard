/**
 *  BulletinBoard
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BulletinBoard

/**
 * A bulletin item that demonstrates how to integrate a date picker inside a bulletin item.
 */

class DatePickerBulletinItem: PageBulletinItem {

    lazy var datePicker = UIDatePicker()

    /**
     * Display the date picker under the description label.
     */

    override func viewsUnderDescription(_ interfaceBuilder: BulletinInterfaceBuilder) -> [UIView]? {
        datePicker.datePickerMode = .date
        return [datePicker]
    }

}
