//
//  ContentView.swift
//  test_task_ios2
//
//  Created by Edward Gasparian on 12.06.2025.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject private var bt = BluetoothManager()
    
    var body: some View {
        VStack(spacing: 16) {
            // Bluetooth state indicator
            Text("Bluetooth: \(stateDescription(bt.bluetoothState))")
                .foregroundColor(bt.bluetoothState == .poweredOn ? .green : .red)
            
            // Scan / Stop
            HStack {
                Button("Scan")  { bt.startScan() }
                    .disabled(bt.bluetoothState != .poweredOn)
                
                Button("Stop")  { bt.stopScan()  }
                    .disabled(bt.bluetoothState != .poweredOn)
            }
            .buttonStyle(.borderedProminent)
            
            // List of discovered peripherals
            List(bt.discovered) { info in
                HStack {
                    VStack(alignment: .leading) {
                        Text(info.name)
                            .bold()
                        Text("RSSI: \(info.rssi)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Button(info.isConnected ? "Disconnect" : "Connect") {
                        bt.toggleConnection(for: info)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(info.isConnected ? .red : .blue)
                }
            }
            .listStyle(.plain)
        }
        .preferredColorScheme(.dark)
        .padding()
    }
        
    
    private func stateDescription(_ state: CBManagerState) -> String {
        switch state {
        case .poweredOn:      return "ON"
        case .poweredOff:     return "OFF"
        case .unauthorized:   return "unauthorized"
        case .unsupported:    return "unsupported"
        case .resetting:      return "resetting"
        default:              return "unknown"
        }
    }
}

#Preview {
    ContentView()
}
