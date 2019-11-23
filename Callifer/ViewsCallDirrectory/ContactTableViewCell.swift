//
//  ContactTableViewCell.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 15.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit
class ContactTableViewCell: UITableViewCell {
       
    private lazy var nameLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        let font = UIFont.boldSystemFont(ofSize: 14)
        label.font = font
        return label
    }()
    
    private lazy var nameDescriptionLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        let font = UIFont.systemFont(ofSize: 10.0)
        label.font = font
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        return label
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameDescriptionLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        setConstraint()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraint() {
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0).isActive = true
        nameDescriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 2.0).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0).isActive = true
        
        nameDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        numberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        
        nameDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true

        numberLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/3).isActive = true

    }

    func setNumber(contact: Contact){
        numberLabel.text = contact.number
        nameLabel.text = contact.name
        nameDescriptionLabel.text = contact.description
    }
    
}

