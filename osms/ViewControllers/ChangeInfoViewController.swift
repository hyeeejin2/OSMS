//
//  ChangeInfoViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/25.
//

import UIKit
import Alamofire

struct infoResponse: Decodable {
    let result: String
    let id: String
    let pw: String
    let name: String
    let birthdate: String
    let bloodtype: String
    let height: Int
    let weight: Int
    let medicine: String
    let disease: String
}

class ChangeInfoViewController: UIViewController {
    
    var verticalSV: UIStackView = UIStackView()
    var horizontalSV: UIStackView = UIStackView()
    var values: [UITextField] = [UITextField]()
    var spacing: [UILabel] = [UILabel]()
    var changeBTN: UIButton = UIButton()
    var data = [String: Any]()
    let bloodTypeList = ["--선택--", "A", "B", "AB", "O"]
    var selectedCategory = ""
    var selectedIdx = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        createPickerView()
        dismissPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = [String: Any]()
        getInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
    func setView() {
        self.navigationItem.title = "회원정보수정"
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 15
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        view.addSubview(verticalSV)
        verticalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let idValue = UITextField()
        idValue.tag = 0
        idValue.placeholder = "아이디"
        idValue.borderStyle = .roundedRect
        idValue.isEnabled = false
        idValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(idValue)
        
        let pwValue = UITextField()
        pwValue.tag = 1
        pwValue.placeholder = "비밀번호"
        pwValue.borderStyle = .roundedRect
        pwValue.isSecureTextEntry = true
        pwValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(pwValue)
        
        let nameValue = UITextField()
        nameValue.tag = 2
        nameValue.placeholder = "이름"
        nameValue.borderStyle = .roundedRect
        nameValue.isEnabled = false
        nameValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(nameValue)
        
        let birthDateValue = UITextField()
        birthDateValue.tag = 3
        birthDateValue.placeholder = "생년월일 예) 990329"
        birthDateValue.borderStyle = .roundedRect
        birthDateValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(birthDateValue)
        
        let bloodTypeValue = UITextField()
        bloodTypeValue.tag = 4
        bloodTypeValue.placeholder = "혈액형"
        bloodTypeValue.borderStyle = .roundedRect
        bloodTypeValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(bloodTypeValue)
        
        horizontalSV.axis = .horizontal
        horizontalSV.alignment = .fill
        horizontalSV.distribution = .fill
        horizontalSV.spacing = 10
        horizontalSV.translatesAutoresizingMaskIntoConstraints = false
        horizontalSV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let heightValue = UITextField()
        heightValue.tag = 5
        heightValue.placeholder = "키"
        heightValue.borderStyle = .roundedRect
        heightValue.keyboardType = .numberPad
        heightValue.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        values.append(heightValue)
        
        let weightValue = UITextField()
        weightValue.tag = 6
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
        
        horizontalSV.addArrangedSubview(values[5])
        horizontalSV.addArrangedSubview(spacing[0])
        horizontalSV.addArrangedSubview(values[6])
        horizontalSV.addArrangedSubview(spacing[1])
        heightValue.widthAnchor.constraint(equalTo: weightValue.widthAnchor).isActive = true
        spacing[0].widthAnchor.constraint(equalTo: spacing[1].widthAnchor).isActive = true
        
        let medicineValue = UITextField()
        medicineValue.tag = 7
        medicineValue.placeholder = "복용 중인 약"
        medicineValue.borderStyle = .roundedRect
        medicineValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(medicineValue)
        
        let diseaseValue = UITextField()
        diseaseValue.tag = 8
        diseaseValue.placeholder = "현재 앓고 있는 질병 또는 질환"
        diseaseValue.borderStyle = .roundedRect
        diseaseValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        values.append(diseaseValue)
        
        changeBTN.setTitle("수정 완료", for: .normal)
        changeBTN.backgroundColor = .systemBlue
        changeBTN.layer.cornerRadius = 10 // 모서리 굴곡률
        changeBTN.heightAnchor.constraint(equalToConstant: 40).isActive = true
        changeBTN.addTarget(self, action: #selector(changeBTNPressed(_:)), for: .touchUpInside)
        
        verticalSV.addArrangedSubview(values[0])
        verticalSV.addArrangedSubview(values[1])
        verticalSV.addArrangedSubview(values[2])
        verticalSV.addArrangedSubview(values[3])
        verticalSV.addArrangedSubview(values[4])
        verticalSV.addArrangedSubview(horizontalSV)
        verticalSV.addArrangedSubview(values[7])
        verticalSV.addArrangedSubview(values[8])
        verticalSV.addArrangedSubview(changeBTN)
    }
    
    func createPickerView() {
        let bloodTypePickerView: UIPickerView = UIPickerView()
        bloodTypePickerView.delegate = self
        bloodTypePickerView.dataSource = self
        values[4].inputView = bloodTypePickerView
    }
    
    func dismissPickerView() {
        let bloodTypePickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        bloodTypePickerToolBar.sizeToFit()
        bloodTypePickerToolBar.isTranslucent = true
        
        let bloodTypeBtnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(bloodTypePickerDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        bloodTypePickerToolBar.setItems([space, bloodTypeBtnDone], animated: true)
        bloodTypePickerToolBar.isUserInteractionEnabled = true
        values[4].inputAccessoryView = bloodTypePickerToolBar
    }
    
    @objc func bloodTypePickerDone() {
        values[4].text = selectedCategory
        self.view.endEditing(true)
    }
    
    func getInfo() {
        let url = "http://localhost:3000/getInfo"
        let params: Parameters = ["userID": UserInfo.userID]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<500)
            .responseDecodable { (response: DataResponse<infoResponse, AFError>) in
                let status: Int = response.response!.statusCode
                switch status {
                case 200:
                    let values = response.value!
                    self.data["id"] = values.id
                    self.data["pw"] = values.pw
                    self.data["name"] = values.name
                    self.data["birthdate"] = values.birthdate
                    self.data["bloodtype"] = values.bloodtype
                    self.data["height"] = values.height
                    self.data["weight"] = values.weight
                    self.data["medicine"] = values.medicine
                    self.data["disease"] = values.disease
                    self.setValue()
                case 400:
                    self.showAlert(message: "회원정보 불러오기 실패") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                case 500:
                    self.showAlert(message: "회원정보 불러오기 실패") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    self.showAlert(message: "회원정보 불러오기 실패") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
    }
    
    func setValue() {
        values[0].text = data["id"] as? String
        values[2].text = data["name"] as? String
        values[3].text = data["birthdate"] as? String
        values[4].text = data["bloodtype"] as? String
        values[5].text = "\(data["height"]!)"
        values[6].text = "\(data["weight"]!)"
        values[7].text = data["medicine"] as? String
        values[8].text = data["disease"] as? String
    }
    
    @objc func changeBTNPressed(_ sender: UIButton) {
        for i in 0..<values.count {
            guard let str: String = values[i].text, str.isEmpty == false else {
                showAlert(message: "빈칸을 채워주세요", handler: nil)
                return
            }
        }
        
        guard data["pw"] as? String == values[1].text else {
            showAlert(message: "비밀번호를 확인해주세요", handler: nil)
            return
        }
        
        let userID: String = values[0].text!
        let birthdate: String = values[3].text!
        let bloodtype: String = values[4].text!
        guard let height: Int = Int(values[5].text!) else { return }
        guard let weight: Int = Int(values[6].text!) else { return }
        let medicine: String = values[7].text!
        let disease: String = values[8].text!
        
        changeInfoProcess(userID: userID, birthdate: birthdate, bloodtype: bloodtype, height: height, weight: weight, medicine: medicine, disease: disease)
        
   }
    
    func changeInfoProcess(userID: String, birthdate: String, bloodtype: String, height: Int, weight: Int, medicine: String, disease: String){
        let url = "http://localhost:3000/changeInfoProcess"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = ["userID": userID, "birthdate": birthdate, "bloodtype": bloodtype,
                      "height": height, "weight": weight, "medicine": medicine, "disease": disease] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Http Body Error")
        }

        AF.request(request).responseDecodable { (response: DataResponse<response, AFError>) in
            let status: Int = response.response!.statusCode
            switch status {
            case 200:
                self.showAlert(message: "회원정보 수정 완료") { action in
                    self.navigationController?.popViewController(animated: true)
                }
            case 400:
                self.showAlert(message: "회원정보 수정 실패", handler: nil)
            case 500:
                self.showAlert(message: "회원정보 수정 실패", handler: nil)
            default:
                self.showAlert(message: "회원정보 수정 실패", handler: nil)
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
extension ChangeInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
