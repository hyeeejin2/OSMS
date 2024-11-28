//
//  ChangePasswordViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/25.
//

import UIKit
import Alamofire

struct pwResponse: Decodable {
    let result: String
    let pw: String
}

class ChangePasswordViewController: UIViewController {

    var verticalSV: UIStackView = UIStackView()
    var values: [UITextField] = [UITextField]()
    var changeBTN: UIButton = UIButton()
    var nowPW: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nowPW = ""
        getPW()
    }
    
    func setView() {
        self.navigationItem.title = "비밀번호변경"
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let nowValue = UITextField()
        nowValue.tag = 0
        nowValue.placeholder = "현재 비밀번호"
        nowValue.borderStyle = .roundedRect
        nowValue.isSecureTextEntry = true
        nowValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(nowValue)
    
        let newValue = UITextField()
        newValue.tag = 1
        newValue.placeholder = "새로운 비밀번호"
        newValue.borderStyle = .roundedRect
        newValue.isSecureTextEntry = true
        newValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(newValue)
        
        let newCheckValue = UITextField()
        newCheckValue.tag = 2
        newCheckValue.placeholder = "새로운 비밀번호 확인"
        newCheckValue.borderStyle = .roundedRect
        newCheckValue.isSecureTextEntry = true
        newCheckValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(newCheckValue)
        
        changeBTN.setTitle("비밀번호 변경", for: .normal)
        changeBTN.backgroundColor = .systemBlue
        changeBTN.layer.cornerRadius = 10
        changeBTN.heightAnchor.constraint(equalToConstant: 40).isActive = true
        changeBTN.addTarget(self, action: #selector(changeBTNPressed(_:)), for: .touchUpInside)
        
        verticalSV.addArrangedSubview(nowValue)
        verticalSV.addArrangedSubview(newValue)
        verticalSV.addArrangedSubview(newCheckValue)
        verticalSV.addArrangedSubview(changeBTN)
    }
    
    func getPW() {
        let url = "http://localhost:3000/getPW"
        let params: Parameters = ["userID": UserInfo.userID]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<pwResponse, AFError>) in
                let status: Int = response.response!.statusCode
                switch status {
                case 200:
                    let values = response.value!
                    self.nowPW = values.pw
                case 400:
                    self.showAlert(message: "알 수 없는 오류") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                case 500:
                    self.showAlert(message: "알 수 없는 오류") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    self.showAlert(message: "알 수 없는 오류") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
    }
    
    @objc func changeBTNPressed(_ sender: UIButton) {
        for i in 0..<values.count {
            guard let str: String = values[i].text, str.isEmpty == false else {
                showAlert(message: "빈칸을 채워주세요", handler: nil)
                return
            }
        }
        
        // 새로운 비밀번호 == 새로운 비밀번호 확인
        guard let new: String = values[1].text, let newCheck: String = values[2].text, new == newCheck else {
            showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            return
        }
        
        // 현재 비밀번호 != 새로운 비밀번호
        guard let now: String = values[0].text, now != new else {
            showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            return
        }
        
        // 현재 비밀번호 == 실제 비밀번호
        guard now == nowPW else {
            showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            return
        }
        
        changeProcess(newPW: new)
    }
    
    func changeProcess(newPW: String) {
        let url = "http://localhost:3000/changePWProcess"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = ["userID": UserInfo.userID, "newPW": newPW] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Http Body Error")
        }

        AF.request(request).responseDecodable { (response: DataResponse<loginResponse, AFError>) in
            let status: Int = response.response!.statusCode
            switch status {
            case 200:
                self.showAlert(message: "비밀번호변경 성공") { action in
                    self.navigationController?.popViewController(animated: true)
                }
            case 400:
                self.showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            case 500:
                self.showAlert(message: "비밀번호 변경 실패", handler: nil)
            default:
                self.showAlert(message: "비밀번호 변경 실패", handler: nil)
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
