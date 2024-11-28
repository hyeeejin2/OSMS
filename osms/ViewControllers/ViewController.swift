//
//  ViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2021/11/28.
//

import UIKit
import CoreBluetooth

//struct response: Decodable {
//    let result: String
//}

class ViewController: UIViewController {
    
    var verticalSV: UIStackView = UIStackView()
    var searchBTN: UIButton = UIButton()
    var state: UILabel = UILabel()
    var centralManagers: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var writeType: CBCharacteristicWriteType = .withoutResponse
    var serviceUUID = CBUUID(string: "c1ca3524-fdc2-4859-bbbb-be3ae9f45d9f") //FFE0
    var characteristicUUID = CBUUID(string : "4b4db62d-e153-4dcb-b5ca-21d2485eee81") //FFE1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        centralManagers = CBCentralManager(delegate: self, queue: nil)
    }
    
    func setView() {
        view.backgroundColor = .white
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        searchBTN.tag = 0
        searchBTN.setTitle("작업장 검색", for: .normal)
        searchBTN.backgroundColor = .systemBlue
        searchBTN.layer.cornerRadius = 5
        searchBTN.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBTN.addTarget(self, action: #selector(searchBtnPressed(_:)), for: .touchUpInside)
        
        state.text = ""
        state.textColor = .black
        state.textAlignment = .center
        state.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        verticalSV.addArrangedSubview(searchBTN)
        verticalSV.addArrangedSubview(state)
    }
    
    @objc func searchBtnPressed(_ sender: UIButton) {
        if(searchBTN.tag == 0) {
            startScan()
            searchBTN.setTitle("작업장 검색 종료", for: .normal)
            //state.text = "검색을 시작합니다"
        } else {
            stopScan()
            searchBTN.setTitle("작업장 검색", for: .normal)
            //state.text = "검색을 종료합니다"
        }
    }
    
    func startScan() {
        guard centralManagers.state == .poweredOn else { return }
               
        centralManagers.scanForPeripherals(withServices: nil) // Scan peripheral device
        searchBTN.tag = 1
    }
    func stopScan() {
        centralManagers.stopScan()
        searchBTN.tag = 0
    }
}


extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown:
//            print("central.state is unknown")
//        case .resetting:
//            print("central.state is resetting")
//        case .unsupported:
//            print("central.state is unsupported")
//        case .unauthorized:
//            print("central.state is unauthorized")
//        case .poweredOff:
//            print("central.state is poweredOff")
//        case .poweredOn:
//            print("central.state is poweredOn")
//            centralManagers.scanForPeripherals(withServices: nil) // Scan peripheral device
//        @unknown default:
//            print("central.state default case")
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral) // 주변 기기 출력
        
        if peripheral.identifier.uuidString == "FA919845-0C6F-75AE-1941-91B9190748FC" {
            self.arduinoPeripheral = peripheral
            arduinoPeripheral.delegate = self
            centralManagers.stopScan()
            centralManagers.connect(arduinoPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        
        peripheral.discoverServices([serviceUUID]) // nill or serviceUUID
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices")
        
        
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            print("\tservice description: ", service.description)
            peripheral.discoverCharacteristics([characteristicUUID], for: service) // nill or characteristicUUID

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristicsFor")
        
        guard let characteristics = service.characteristics else {
            return
            
        }
        
        for characteristic in characteristics {
            print("characteristic description:", characteristic.description)
            if characteristic.uuid == characteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic)
                writeCharacteristic = characteristic
                writeType = characteristic.properties.contains(.write) ? .withResponse :  .withoutResponse
                let data: Data = DeviceToken.deviceToken.data(using: .utf8)!
                // e377209dda5a91fb4fc599ac8cecd013bc520b2bf76ae699e9e724f99034d594
                peripheral.writeValue(data, for: writeCharacteristic, type: writeType)
                
                showAlert(message: "작업장 연결 성공") { action in
                    self.state.text = "작업장에 연결되었습니다"
                    self.searchBTN.isHidden = true
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        arduinoPeripheral = nil

        state.text = "작업장에 연결되어있지 않습니다"
        searchBTN.isHidden = false
    }
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
