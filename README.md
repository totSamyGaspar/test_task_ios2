# test_task_ios2

Simple iOS demo that scans for BLE devices, lets you connect / disconnect each one individually, and keeps the link alive in background.

---

## Features
- Enable / request Bluetooth permission on first launch 
- Live scan list with RSSI, auto-sorted (strongest first) 
- **Connect / Disconnect** per row, many devices at once 
- Auto-reconnect on unexpected drop 
- Works in background thanks to `bluetooth-central` mode 
- Written 100 % in **SwiftUI + CoreBluetooth** (no storyboards)

---

## Requirements
* Xcode 15 +
* Swift 5.9
* iOS 16.0 + (deployment target)

---
## Info.plist essentials
   Make sure these keys are present before releasing:
   
Key / Why it’s needed / Example value
             
NSBluetoothAlwaysUsageDescription / Mandatory alert text; app crashes without it / App needs Bluetooth to scan & connect to nearby BLE devices

NSBluetoothPeripheralUsageDescription / Recommended fallback for older iOS / App communicates with BLE peripherals
                                                                                                                
UIBackgroundModes → bluetooth-central / Keeps scan / connection alive when app goes to background or screen locks / (array item) => App communicates using CoreBluetooth

(After edits do Product ▸ Clean Build Folder and reinstall the app to verify that the keys are inside the final Info.plist.)

## Build & Run

```bash
git clone https://github.com/<your-name>/test_task_ios2.git
open test_task_ios2/test_task_ios2.xcodeproj
# Select real iPhone — BLE is unavailable in Simulator
⌘R             # build & run
```
---
## Sreenshots:
![1](https://github.com/user-attachments/assets/1cfe961a-6384-4a73-9d8f-c3b9ea3f2a4f)
![2](https://github.com/user-attachments/assets/42025ac7-b016-410f-858d-5fc706281044)
![3](https://github.com/user-attachments/assets/e1e0fa00-2e0d-4bec-891f-302604b054ec)
![4](https://github.com/user-attachments/assets/a38a0b5d-cabd-401c-aa9e-2e7aad2e6d54)
---
## DemoVideo:
Youtube:  https://youtube.com/shorts/7FeO67k7hYI?feature=share
