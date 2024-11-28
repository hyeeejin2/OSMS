//
//  MainViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2021/11/28.
//

import UIKit
import CoreBluetooth
import Alamofire

struct response: Decodable {
    let result: String
}
struct pushResponse: Decodable {
    let result: [dataList]
}
struct dataList: Decodable {
    let DATE: String
    let P_ZIGBEE: String
    let CONTENT: String
}

class MainViewController: UIViewController {

    var verticalSV: UIStackView = UIStackView()
    var searchBTN: UIButton = UIButton()
    var stateLabel: UILabel = UILabel()
    let now: Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    let pushTableView: UITableView = UITableView()
    var centralManagers: CBCentralManager!
    var arduinoPeripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var writeType: CBCharacteristicWriteType = .withoutResponse
    var serviceUUID = CBUUID(string: "c1ca3524-fdc2-4859-bbbb-be3ae9f45d9f")
    var characteristicUUID = CBUUID(string : "4b4db62d-e153-4dcb-b5ca-21d2485eee81")
    var connected: Bool = false
    let sections: [String] = ["오늘 알림 내역"]
    var dataList = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        centralManagers = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(connected) {
            stateLabel.text = "작업장에 연결되었습니다"
            searchBTN.isHidden = true
        } else {
            stateLabel.text = "작업장에 연결되어있지 않습니다"
            searchBTN.isHidden = false
        }
        dataList = [[String: String]]()
        getTodayPushInfoProcess()
    }

    func setView() {
        view.backgroundColor = .white
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        searchBTN.tag = 0
        searchBTN.setTitle("작업장 검색", for: .normal)
        searchBTN.backgroundColor = .systemBlue
        searchBTN.layer.cornerRadius = 5
        searchBTN.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBTN.addTarget(self, action: #selector(searchBtnPressed(_:)), for: .touchUpInside)
        
        stateLabel.text = ""
        stateLabel.textColor = .black
        stateLabel.textAlignment = .center
        stateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        verticalSV.addArrangedSubview(searchBTN)
        verticalSV.addArrangedSubview(stateLabel)
        
        pushTableView.translatesAutoresizingMaskIntoConstraints = false
        pushTableView.register(MainCustomCell.self, forCellReuseIdentifier: MainCustomCell.identifier)
        
        pushTableView.delegate = self
        pushTableView.dataSource = self

        view.addSubview(pushTableView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pushTableView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 20),
            pushTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            pushTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            pushTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    @objc func searchBtnPressed(_ sender: UIButton) {
        if(searchBTN.tag == 0) {
            startScan()
            searchBTN.setTitle("작업장 검색 종료", for: .normal)
        } else {
            stopScan()
            searchBTN.setTitle("작업장 검색", for: .normal)
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
    
    func getTodayPushInfoProcess() {
        let url = "http://localhost:3000/getTodayPushInfo"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: now)
        let params: Parameters = ["userID": UserInfo.userID, "today": today]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<pushResponse, AFError>) in
                let status: Int = response.response!.statusCode
                switch status {
                case 200:
                    let values = response.value!
                    for i in 0..<values.result.count {
                        let temp = ["date": values.result[i].DATE, "zigbee": values.result[i].P_ZIGBEE, "content": values.result[i].CONTENT]
                        self.dataList.append(temp)
                    }
                    self.pushTableView.reloadData()
                case 400:
                    self.showAlert(message: "알림 내역 불러오기 실패", handler: nil)
                case 500:
                    self.showAlert(message: "알림 내역 불러오기 실패", handler: nil)
                default:
                    self.showAlert(message: "알림 내역 불러오기 실패", handler: nil)
                }
            }
    }
}

extension MainViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) { }
    
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
        
        stateLabel.text = "작업장에 연결되었습니다"
        searchBTN.isHidden = true
        connected = true
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
                let data: Data = "e377209dda5a91fb4fc599ac8cecd013bc520b2bf76ae699e9e724f99034d594".data(using: .utf8)!
                print(data)
                // e377209dda5a91fb4fc599ac8cecd013bc520b2bf76ae699e9e724f99034d594
                peripheral.writeValue(data, for: writeCharacteristic, type: writeType)
                
                showAlert(message: "작업장 연결 성공") { action in
                    self.stateLabel.text = "작업장에 연결되었습니다"
                    self.searchBTN.isHidden = true
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        arduinoPeripheral = nil

        stateLabel.text = "작업장에 연결되어있지 않습니다"
        searchBTN.isHidden = false
        connected = false
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell은 as 키워드로 앞서 만든 HomeCalendarCustomCell 클래스화
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCustomCell", for: indexPath) as! MainCustomCell

        // cell에 데이터 삽입
        let data = dataList[indexPath.row]
        cell.dateLabel.text = data["date"]
        cell.zigbeeLabel.text = data["zigbee"]
        cell.contentLabel.text = "🚨 "+data["content"]!+" 🚨"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
