//
//  Model.swift
//  test_task_ios2
//
//  Created by Edward Gasparian on 12.06.2025.
//

import Foundation
import CoreBluetooth

struct PeripheralInfo: Identifiable, Hashable {
    let id: UUID
    var name: String
    let peripheral: CBPeripheral
    var rssi: NSNumber
    var isConnected: Bool = false
}
