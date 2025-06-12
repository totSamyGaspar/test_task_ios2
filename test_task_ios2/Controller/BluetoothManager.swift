//
//  BluetoothManager.swift
//  test_task_ios2
//
//  Created by Edward Gasparian on 12.06.2025.
//

import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    
    @Published var bluetoothState: CBManagerState = .unknown
    @Published var discovered: [PeripheralInfo] = []
    
    private var central: CBCentralManager!
    private var connected: [UUID: CBPeripheral] = [:]
    
    // Make the manager and ask iOS for Bluetooth access
    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Public helpers
    // Connects if peripheral is disconnected, otherwise cancels connection
    func toggleConnection(for info: PeripheralInfo) {
        if let p = connected[info.id] {
            central.cancelPeripheralConnection(p)
        } else {
            central.connect(info.peripheral, options: nil)
        }
    }
    // Start looking for nearby BLE devices
    func startScan() {
        guard bluetoothState == .poweredOn else { return }
        discovered.removeAll()
        central.scanForPeripherals(withServices: nil,
                                   options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    // Stops scanning to save battery
    func stopScan() { central.stopScan() }
}

// MARK: - CBCentralManagerDelegate
// Called whenever the Bluetooth adapter changes state
extension BluetoothManager: CBCentralManagerDelegate {
    // Fires whenever user turns BT on/off, or after app launch
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothState = central.state
        if central.state == .poweredOn { startScan() }
    }
    
    // Called every time we “hear” a BLE advertisement
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        
        let id   = peripheral.identifier
        let name = (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ??
        peripheral.name ?? "Unnamed"
        
        // Device already in list → just refresh info
        if let idx = discovered.firstIndex(where: { $0.id == id }) {
            discovered[idx].rssi = RSSI
            discovered[idx].name = name
            discovered[idx].isConnected = connected[id] != nil
            return
        }
        
        // If new device -> add it
        var info = PeripheralInfo(id: id,
                                  name: name,
                                  peripheral: peripheral,
                                  rssi: RSSI)
        
        info.isConnected = connected[id] != nil
        discovered.append(info)
        // Keep strongest signal first
        discovered.sort { $0.rssi.intValue > $1.rssi.intValue }
    }
    
    // Connected to a device
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        connected[peripheral.identifier] = peripheral
        update(flag: true, for: peripheral.identifier)
    }
    
    // Device disconnected (or we called Cancel)
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        connected.removeValue(forKey: peripheral.identifier)
        update(flag: false, for: peripheral.identifier)
    }
    
    // Helper that marks device as connected / disconnected in the list
    private func update(flag: Bool, for id: UUID) {
        if let idx = discovered.firstIndex(where: { $0.id == id }) {
            discovered[idx].isConnected = flag
        }
    }
}

// MARK: - Peripheral-level callbacks (not used yet)
extension BluetoothManager: CBPeripheralDelegate {
    // Implement peripheral delegate methods when you need services/characteristics
}
