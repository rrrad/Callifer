//
//  GroupeCollectionViewCell.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 17.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class GroupeCollectionViewCell: UICollectionViewCell {
    
    private var actionButton: (() -> Void)?
    
    private lazy var button: UILabel = {
        let button = UILabel.init(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textAlignment = .center
        button.backgroundColor = .orange
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive =  true
    }
    
    func setTitle(title: String) {
        button.text = title
    }
    
//    func setActionButton(action: (() -> Void)?) {
//        actionButton = action
//    }
//    
//    @objc
//    func action1() {
//        if actionButton != nil {
//            actionButton!()
//        }
//    }
}
