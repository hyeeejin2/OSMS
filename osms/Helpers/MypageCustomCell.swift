//
//  MypageCustomCell.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/25.
//

import UIKit

class MypageCustomCell: UITableViewCell {
    
    static let identifier = "MypageCustomCell"
 
    let menuImage: UIImageView = {
        let Image = UIImageView()
        Image.translatesAutoresizingMaskIntoConstraints = false
        return Image
    }()
    let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraint()
    }
    
    func setConstraint() {
        contentView.addSubview(menuImage)
        contentView.addSubview(menuLabel)
        
        let margin1: CGFloat = 10
        let margin2: CGFloat = 20
        NSLayoutConstraint.activate([
            menuImage.topAnchor.constraint(equalTo: self.topAnchor, constant: margin1),
            menuImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin2),
            menuImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin1),
            menuImage.widthAnchor.constraint(equalToConstant: 30),
            menuImage.heightAnchor.constraint(equalToConstant: 30),
            
            menuLabel.topAnchor.constraint(equalTo: menuImage.topAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: menuImage.trailingAnchor, constant: margin2),
            menuLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin1),
            menuLabel.bottomAnchor.constraint(equalTo: menuImage.bottomAnchor)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
