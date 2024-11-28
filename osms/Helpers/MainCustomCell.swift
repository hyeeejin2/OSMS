//
//  MainCustomCell.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/05/29.
//

import UIKit

class MainCustomCell: UITableViewCell {

    static let identifier = "MainCustomCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let zigbeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contentLabel: UILabel = {
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
        contentView.addSubview(dateLabel)
        contentView.addSubview(zigbeeLabel)
        contentView.addSubview(contentLabel)
        
        let margin1: CGFloat = 10
        let margin2: CGFloat = 20
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin1),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin2),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin2),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            zigbeeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: margin1),
            zigbeeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            zigbeeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin1),
            zigbeeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            contentLabel.topAnchor.constraint(equalTo: zigbeeLabel.topAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: zigbeeLabel.bottomAnchor),
            contentLabel.heightAnchor.constraint(equalTo: zigbeeLabel.heightAnchor),
            contentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 300)
            
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
