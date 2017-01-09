//
//  BluetoothManager.swift
//  SWADevice
//
//  Created by Jay Tucker on 1/9/17.
//  Copyright © 2017 Imprivata. All rights reserved.
//

import CoreBluetooth

class BluetoothManager: NSObject {
    
    fileprivate let serviceUUID        = CBUUID(string: "1FE5D02C-78AB-414D-AD97-1A4E5297227A")
    fileprivate let characteristicUUID = CBUUID(string: "8C881368-8C34-41FD-8BCC-AD7EA408B1EE")
    
    fileprivate var peripheralManager: CBPeripheralManager!
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    fileprivate func addService() {
        log("addService")
        peripheralManager.stopAdvertising()
        peripheralManager.removeAllServices()
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .notify, value: nil, permissions: .readable)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
    }
    
    fileprivate func startAdvertising() {
        log("startAdvertising")
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var caseString: String!
        switch peripheral.state {
        case .unknown:
            caseString = "unknown"
        case .resetting:
            caseString = "resetting"
        case .unsupported:
            caseString = "unsupported"
        case .unauthorized:
            caseString = "unauthorized"
        case .poweredOff:
            caseString = "poweredOff"
        case .poweredOn:
            caseString = "poweredOn"
        }
        log("peripheralManagerDidUpdateState \(caseString!)")
        if peripheral.state == .poweredOn {
            addService()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        let message = "peripheralManager didAddService " + (error == nil ? "ok" :  ("error " + error!.localizedDescription))
        log(message)
        if error == nil {
            startAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        let message = "peripheralManagerDidStartAdvertising " + (error == nil ? "ok" :  ("error " + error!.localizedDescription))
        log(message)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        log("peripheralManager didSubscribeTo characteristic")
    }
    
}
