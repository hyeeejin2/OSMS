//
//  NotificationHistoryViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/05/29.
//

import UIKit
import Alamofire

class NotificationHistoryViewController: UIViewController {

    let pushTableView: UITableView = UITableView()
    let sections: [String] = ["전체 알림 내역"]
    var dataList = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }

    override func viewWillAppear(_ animated: Bool) {
        dataList = [[String: String]]()
        getPushInfoProcess()
    }
    
    func setView() {
        self.navigationItem.title = "전체알림내역"
        
        pushTableView.translatesAutoresizingMaskIntoConstraints = false
        pushTableView.register(MainCustomCell.self, forCellReuseIdentifier: MainCustomCell.identifier)
        
        pushTableView.delegate = self
        pushTableView.dataSource = self

        view.addSubview(pushTableView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pushTableView.topAnchor.constraint(equalTo: guide.topAnchor),
            pushTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            pushTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            pushTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    func getPushInfoProcess() {
        let url = "http://localhost:3000/getPushInfo"
        let params: Parameters = ["userID": UserInfo.userID]
        
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
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "알림",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NotificationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
