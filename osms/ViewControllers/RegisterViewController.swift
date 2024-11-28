//
//  RegisterViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/16.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    var verticalSV: UIStackView = UIStackView()
    var horizontalSV1: UIStackView = UIStackView()
    var horizontalSV2: UIStackView = UIStackView()
    var values: [UITextField] = [UITextField]()
    var spacing: [UILabel] = [UILabel]()
    var overlapBTN: UIButton = UIButton()
    var registerBTN: UIButton = UIButton()
    let bloodTypeList = ["--선택--", "A", "B", "AB", "O"]
    var selectedCategory = ""
    var selectedIdx = 0
    var overlapCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setView()
        createPickerView()
        dismissPickerView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }

    func setView() {
        self.navigationItem.title = "회원가입"
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 15
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        horizontalSV1.axis = .horizontal
        horizontalSV1.alignment = .fill
        horizontalSV1.distribution = .fill
        horizontalSV1.spacing = 10
        horizontalSV1.translatesAutoresizingMaskIntoConstraints = false
        horizontalSV1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let idValue = UITextField()
        idValue.tag = 0
        idValue.placeholder = "아이디"
        idValue.borderStyle = .roundedRect
        idValue.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        values.append(idValue)

        overlapBTN.setTitle("중복확인", for: .normal)
        //overlapBTN.titleLabel?.font = UIFont(name: "System - System", size: 14.0)
        overlapBTN.backgroundColor = .systemBlue
        overlapBTN.layer.cornerRadius = 5 // 모서리 굴곡률
        overlapBTN.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        overlapBTN.addTarget(self, action: #selector(overlapBTNPressed(_:)), for: .touchUpInside)
        
        horizontalSV1.addArrangedSubview(values[0])
        horizontalSV1.addArrangedSubview(overlapBTN)
        
        let pwValue = UITextField()
        pwValue.tag = 1
        pwValue.placeholder = "비밀번호"
        pwValue.borderStyle = .roundedRect
        pwValue.isSecureTextEntry = true
        pwValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(pwValue)
        
        let pwCheckValue = UITextField()
        pwCheckValue.tag = 2
        pwCheckValue.placeholder = "비밀번호 확인"
        pwCheckValue.borderStyle = .roundedRect
        pwCheckValue.isSecureTextEntry = true
        pwCheckValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(pwCheckValue)
        
        let nameValue = UITextField()
        nameValue.tag = 3
        nameValue.placeholder = "이름"
        nameValue.borderStyle = .roundedRect
        nameValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(nameValue)
        
        let birthDateValue = UITextField()
        birthDateValue.tag = 4
        birthDateValue.placeholder = "생년월일 예) 990329"
        birthDateValue.borderStyle = .roundedRect
        birthDateValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(birthDateValue)
        
        let bloodTypeValue = UITextField()
        bloodTypeValue.tag = 5
        bloodTypeValue.placeholder = "혈액형"
        bloodTypeValue.borderStyle = .roundedRect
        bloodTypeValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(bloodTypeValue)
        
        horizontalSV2.axis = .horizontal
        horizontalSV2.alignment = .fill
        horizontalSV2.distribution = .fill
        horizontalSV2.spacing = 10
        horizontalSV2.translatesAutoresizingMaskIntoConstraints = false
        horizontalSV2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let heightValue = UITextField()
        heightValue.tag = 6
        heightValue.placeholder = "키"
        heightValue.borderStyle = .roundedRect
        heightValue.keyboardType = .numberPad
        heightValue.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        values.append(heightValue)
        
        let weightValue = UITextField()
        weightValue.tag = 7
        weightValue.placeholder = "몸무게"
        weightValue.borderStyle = .roundedRect
        weightValue.keyboardType = .numberPad
        weightValue.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        values.append(weightValue)
        
        let cm = UILabel()
        cm.text = "cm"
        cm.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        spacing.append(cm)
        
        let kg = UILabel()
        kg.text = "kg"
        kg.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        spacing.append(kg)
        
        horizontalSV2.addArrangedSubview(values[6])
        horizontalSV2.addArrangedSubview(spacing[0])
        horizontalSV2.addArrangedSubview(values[7])
        horizontalSV2.addArrangedSubview(spacing[1])
        heightValue.widthAnchor.constraint(equalTo: weightValue.widthAnchor).isActive = true
        spacing[0].widthAnchor.constraint(equalTo: spacing[1].widthAnchor).isActive = true
        
        let medicineValue = UITextField()
        medicineValue.tag = 8
        medicineValue.placeholder = "복용 중인 약"
        medicineValue.borderStyle = .roundedRect
        medicineValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(medicineValue)
        
        let diseaseValue = UITextField()
        diseaseValue.tag = 9
        diseaseValue.placeholder = "현재 앓고 있는 질병 또는 질환"
        diseaseValue.borderStyle = .roundedRect
        diseaseValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(diseaseValue)
        
        registerBTN.setTitle("회원가입", for: .normal)
        registerBTN.backgroundColor = .systemBlue
        registerBTN.layer.cornerRadius = 5 // 모서리 굴곡률
        registerBTN.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerBTN.addTarget(self, action: #selector(registerBTNPressed(_:)), for: .touchUpInside)
        
        verticalSV.addArrangedSubview(horizontalSV1)
        verticalSV.addArrangedSubview(values[1])
        verticalSV.addArrangedSubview(values[2])
        verticalSV.addArrangedSubview(values[3])
        verticalSV.addArrangedSubview(values[4])
        verticalSV.addArrangedSubview(values[5])
        verticalSV.addArrangedSubview(horizontalSV2)
        verticalSV.addArrangedSubview(values[8])
        verticalSV.addArrangedSubview(values[9])
        verticalSV.addArrangedSubview(registerBTN)
    }
    
    @objc func overlapBTNPressed(_ sender: UIButton) {
        guard let id: String = values[0].text, id.isEmpty == false else {
            showAlert(message: "아이디를 입력해주세요", handler: nil)
            return
        }
        
        let url = "http://localhost:3000/overlapCheckProcess"
        let params: Parameters = ["userID": id]
        
        overlapCheckProcess(url: url, params: params)
        
    }
    
    @objc func registerBTNPressed(_ sender: UIButton) {
        for i in 0..<values.count {
            guard let str: String = values[i].text, str.isEmpty == false else {
                showAlert(message: "빈칸을 채워주세요", handler: nil)
                return
            }
        }
        
        guard overlapCheck == true else {
            showAlert(message: "아이디 중복확인을 해주세요", handler: nil)
            return
        }
        
        guard let pw: String = values[1].text, let pwCheck: String = values[2].text, pw == pwCheck else {
            showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            return
        }
        
        let id: String = values[0].text!
        let uname: String = values[3].text!
        let birthDate: String = values[4].text!
        let bloodType: String = values[5].text!
        let height: Int = Int(values[6].text!)!
        let weight: Int = Int(values[7].text!)!
        let medicine: String = values[8].text!
        let disease: String = values[9].text!
        registerProcess(userID: id, userPW: pw, uname: uname, birthDate: birthDate, bloodType: bloodType, height: height, weight: weight, medicine: medicine, disease: disease)
        
    }
    
    func createPickerView() {
        let bloodTypePickerView: UIPickerView = UIPickerView()
        bloodTypePickerView.delegate = self
        bloodTypePickerView.dataSource = self
        values[5].inputView = bloodTypePickerView
    }
    
    func dismissPickerView() {
        let bloodTypePickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        bloodTypePickerToolBar.sizeToFit()
        bloodTypePickerToolBar.isTranslucent = true
        
        let bloodTypeBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(bloodTypePickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        bloodTypePickerToolBar.setItems([space, bloodTypeBtnDone], animated: true)
        bloodTypePickerToolBar.isUserInteractionEnabled = true
        values[5].inputAccessoryView = bloodTypePickerToolBar
    }
    
    @objc func bloodTypePickerDone() {
        values[5].text = selectedCategory
        self.view.endEditing(true)
    }
    
    func overlapCheckProcess(url: String, params: Parameters) {
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<response, AFError>) in
                let status: Int = response.response!.statusCode
                switch status {
                case 200:
                    self.showAlert(message: "사용 가능한 아이디입니다") { action in
                        self.overlapCheck = true
                    }
                case 400:
                    self.showAlert(message: "이미 존재하는 아이디입니다") { action in
                        self.overlapCheck = false
                    }
                case 500:
                    self.showAlert(message: "아이디 중복 확인 실패", handler: nil)
                default:
                    self.showAlert(message: "아이디 중복 확인 실패", handler: nil)
                }
            }
    }
    
    func registerProcess(userID: String, userPW: String, uname: String, birthDate: String, bloodType: String, height: Int, weight: Int, medicine: String, disease: String) {
        let url = "http://localhost:3000/registerProcess"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = ["userID": userID, "userPW": userPW, "name": uname, "birthDate": birthDate, "bloodType": bloodType,
                      "height": height, "weight": weight, "medicine": medicine, "disease": disease, "device": DeviceToken.deviceToken] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Http Body Error")
        }

        AF.request(request).responseDecodable { (response: DataResponse<response, AFError>) in
            let status: Int = response.response!.statusCode
            switch status {
            case 200:
                self.showAlert(message: "회원가입 성공") { action in
                    self.navigationController?.popViewController(animated: true)
                }
            case 400:
                self.showAlert(message: "이미 존재하는 아이디입니다", handler: nil)
            case 500:
                self.showAlert(message: "회원가입 실패", handler: nil)
            default:
                self.showAlert(message: "회원가입 실패", handler: nil)
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

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIdx = row
        if row != 0 {
            selectedCategory = bloodTypeList[row]
        } else {
            selectedCategory = ""
        }
    }
}
