/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import CoreLocation

/**
 * Requests permission for system features.
 */

class PermissionsManager {

    static let shared = PermissionsManager()

    let locationManager = CLLocationManager()

    func requestLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            // no-op
        }
    }

    func requestWhenInUseLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

}
