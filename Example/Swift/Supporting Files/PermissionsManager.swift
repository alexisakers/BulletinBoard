/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import CoreLocation
import UserNotifications

/**
 * Requests permission for system features.
 */

class PermissionsManager {

    static let shared = PermissionsManager()

    let locationManager = CLLocationManager()

    func requestLocalNotifications() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in
            // no-op
        }
    }

    func requestWhenInUseLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

}
