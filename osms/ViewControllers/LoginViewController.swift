//
//  LoginViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/16.
//

import UIKit
import Alamofire

struct loginResponse: Decodable {
    let result: String
    let id: String
    let name: String
}

class LoginViewController: UIViewController {

    var verticalSV: UIStackView = UIStackView()
    var horizontalSV: UIStackView = UIStackView()
    var values: [UITextField] = [UITextField]()
    var loginBTN: UIButton = UIButton()
    var registerBTN: UIButton = UIButton()
    var spacing: [UILabel] = [UILabel]()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
    func setView() {
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        let idValue = UITextField()
        idValue.tag = 0
        idValue.placeholder = "아이디"
        idValue.borderStyle = .roundedRect
        idValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(idValue)
        
        let pwValue = UITextField()
        pwValue.tag = 1
        pwValue.placeholder = "비밀번호"
        pwValue.borderStyle = .roundedRect
        pwValue.isSecureTextEntry = true
        pwValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(pwValue)
        
        loginBTN.tag = 0
        loginBTN.setTitle("로그인", for: .normal)
        loginBTN.backgroundColor = .systemBlue
        loginBTN.layer.cornerRadius = 5
        loginBTN.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginBTN.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        
        verticalSV.addArrangedSubview(values[0])
        verticalSV.addArrangedSubview(values[1])
        verticalSV.addArrangedSubview(loginBTN)
        //verticalSV.addArrangedSubview(registerBTN)
        
        horizontalSV.axis = .horizontal
        horizontalSV.alignment = .fill
        horizontalSV.distribution = .fill
        horizontalSV.spacing = 10
        horizontalSV.translatesAutoresizingMaskIntoConstraints = false
        horizontalSV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for _ in 0..<2 {
            let space = UILabel()
            space.text = ""
            spacing.append(space)
        }
        
        registerBTN.tag = 1
        registerBTN.setTitle("회원가입", for: .normal)
        registerBTN.setTitleColor(.black, for: .normal)
        registerBTN.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        registerBTN.layer.cornerRadius = 5 // 모서리 굴곡률
        registerBTN.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerBTN.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        
        horizontalSV.addArrangedSubview(spacing[0])
        horizontalSV.addArrangedSubview(registerBTN)
        horizontalSV.addArrangedSubview(spacing[1])
        registerBTN.widthAnchor.constraint(equalTo: spacing[0].widthAnchor).isActive = true
        registerBTN.widthAnchor.constraint(equalTo: spacing[1].widthAnchor).isActive = true
        
        verticalSV.addArrangedSubview(horizontalSV)
    }
    
    @objc func btnPressed(_ sender: UIButton) {
        if (sender.tag == 0) {
            for i in 0..<values.count {
                guard let str: String = values[i].text, str.isEmpty == false else {
                    showAlert(message: "빈칸을 채워주세요", handler: nil)
                    return
                }
            }
            
            let id: String = values[0].text!
            let pw: String = values[1].text!
            loginProcess(userID: id, userPW: pw)
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let registerViewController = storyboard.instantiateViewController(identifier: Constants.Storyboard.registerViewController) as! RegisterViewController
            self.navigationController?.pushViewController(registerViewController, animated: true)
        }
    }
    
    func loginProcess(userID: String, userPW: String) {
        let url = "http://localhost:3000/loginProcess"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = ["userID": userID, "userPW": userPW] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Http Body Error")
        }

        AF.request(request).responseDecodable { (response: DataResponse<loginResponse, AFError>) in
            let status: Int = response.response!.statusCode
            switch status {
            case 200:
                let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.TabBarController) as! TabBarController
                self.view.window?.rootViewController = tabBarController
                self.view.window?.makeKeyAndVisible()
                
                guard let id = response.value?.id, let name = response.value?.name else {
                    return
                }
                UserInfo.userID = id
                UserInfo.userName = name

            case 400:
                self.showAlert(message: "아이디 또는 비밀번호를 확인해주세요", handler: nil)
            case 500:
                self.showAlert(message: "로그인 실패", handler: nil)
            default:
                self.showAlert(message: "로그인 실패", handler: nil)
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
