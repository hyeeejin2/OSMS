//
//  SearchViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/16.
//

import UIKit
import CoreBluetooth

class SearchViewController: UIViewController {

    var btn: UIButton = UIButton()
    var centralManagers: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    var serviceUUID = CBUUID(string: "FFE0") //FFE0
    var characteristicUUID = CBUUID(string : "FFE1") //FFE1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        centralManagers = CBCentralManager(delegate: self, queue: nil)
        //setView()
    }
    
    func setView() {
        btn.setTitle("작업장 검색", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        //btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //registerBTN.setTitleColor(.black, for: .normal)
        //registerBTN.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        
        view.addSubview(btn)
        //btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //btn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        //btn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    @objc func btnPressed(_ sender: UIButton) {
        print("test")
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
extension SearchViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is unknown")
        case .resetting:
            print("central.state is resetting")
        case .unsupported:
            print("central.state is unsupported")
        case .unauthorized:
            print("central.state is unauthorized")
        case .poweredOff:
            print("central.state is poweredOff")
        case .poweredOn:
            print("central.state is poweredOn")
            centralManagers.scanForPeripherals(withServices: nil) // peripheral device scan
        @unknown default:
            print("central.state default case")
        }
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
        
        peripheral.discoverServices([serviceUUID])
        //peripheral.discoverServices(nil)
        
        showAlert(message: "연결되었습니다", handler: nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices")
        
        
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            print("\tservice description: ", service.description)
            peripheral.discoverCharacteristics([characteristicUUID], for: service)

        }
    }
}
