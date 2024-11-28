//
//  MypageViewController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/16.
//

import UIKit

class MypageViewController: UIViewController {

    var horizontalSV: UIStackView = UIStackView()
    var verticalSV: UIStackView = UIStackView()
    let mypageTableView: UITableView = UITableView()
    let menuList: [[String]] = [["회원정보수정", "비밀번호변경"], ["전체알림내역"], ["로그아웃"]]
    let menuImage: [[String]] = [["person.circle", "key"], ["note.text"], ["power"]]
    let sections: [String] = ["계정", "내역", "기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setView()
    }
    
    func setView() {
        horizontalSV.axis = .horizontal
        horizontalSV.alignment = .fill
        horizontalSV.distribution = .fill
        horizontalSV.spacing = 10
        horizontalSV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(horizontalSV)
        horizontalSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        horizontalSV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        horizontalSV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        horizontalSV.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let profileImg = UIImageView()
        profileImg.image = UIImage(systemName: "person.crop.circle")
        
        horizontalSV.addArrangedSubview(profileImg)
        profileImg.topAnchor.constraint(equalTo: horizontalSV.topAnchor).isActive = true
        profileImg.leadingAnchor.constraint(equalTo: horizontalSV.leadingAnchor).isActive = true
        profileImg.bottomAnchor.constraint(equalTo: horizontalSV.bottomAnchor).isActive = true
        profileImg.widthAnchor.constraint(equalTo: profileImg.heightAnchor).isActive = true
        
        verticalSV.axis = .vertical
        verticalSV.alignment = .fill
        verticalSV.distribution = .fill
        verticalSV.spacing = 10
        verticalSV.translatesAutoresizingMaskIntoConstraints = false // 코드로 Constraint를 줘야할 때 호출
        
        let id = UILabel()
        id.text = UserInfo.userID
        
        let name = UILabel()
        name.text = UserInfo.userName
        
        verticalSV.addArrangedSubview(id)
        verticalSV.addArrangedSubview(name)
        horizontalSV.addArrangedSubview(verticalSV)
        
        verticalSV.topAnchor.constraint(equalTo: profileImg.topAnchor).isActive = true
        verticalSV.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 10).isActive = true
        verticalSV.trailingAnchor.constraint(equalTo: horizontalSV.trailingAnchor).isActive = true
        horizontalSV.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        verticalSV.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        id.heightAnchor.constraint(equalTo: name.heightAnchor).isActive = true
        
        mypageTableView.translatesAutoresizingMaskIntoConstraints = false
        mypageTableView.register(MypageCustomCell.self, forCellReuseIdentifier: MypageCustomCell.identifier)
        
        mypageTableView.delegate = self
        mypageTableView.dataSource = self

        view.addSubview(mypageTableView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mypageTableView.topAnchor.constraint(equalTo: horizontalSV.bottomAnchor, constant: 10),
            mypageTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mypageTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mypageTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

}

extension MypageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuList[0].count
        } else if section == 1 {
            return menuList[1].count
        } else if section == 2 {
            return menuList[2].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MypageCustomCell.identifier, for: indexPath) as! MypageCustomCell

        let idx = indexPath.section
        let data = menuList[idx][indexPath.row]
        cell.menuImage.image = UIImage(systemName: menuImage[idx][indexPath.row])
        cell.menuLabel.text = data
//        let data = menuList[0][indexPath.row]
//        cell.menuImage.image = UIImage(systemName: menuImage[indexPath.row])
//        cell.menuLabel.text = data
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let idx = indexPath.row
        
        if (section == 0) {
            if (idx == 0) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let changeInfoViewController = storyboard.instantiateViewController(identifier: Constants.Storyboard.changeInfoViewController) as! ChangeInfoViewController
                self.navigationController?.pushViewController(changeInfoViewController, animated: true)
            } else if (idx == 1) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let changePasswordViewController = storyboard.instantiateViewController(identifier: Constants.Storyboard.changePasswordViewController) as! ChangePasswordViewController
                self.navigationController?.pushViewController(changePasswordViewController, animated: true)
            }
        } else if (section == 1) {
            if (idx == 0) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let notificationHistoryViewController = storyboard.instantiateViewController(identifier: Constants.Storyboard.notificationHistoryViewController) as! NotificationHistoryViewController
                self.navigationController?.pushViewController(notificationHistoryViewController, animated: true)
            }
        } else {
            if (idx == 0) {
                logout()
            }
        }
    }
    
    func logout() {
        let alert = UIAlertController(title: "로그아웃",
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            UserInfo.userID = ""
            UserInfo.userName = ""
            self.navigationController?.popToRootViewController(animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as! LoginViewController
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
