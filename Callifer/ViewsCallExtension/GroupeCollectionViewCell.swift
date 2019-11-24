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
    
    private lazy var label: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        //label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive =  true
    }
    
    func setTitle(title: String) {
        if title == "+" {
            label.font = UIFont.boldSystemFont(ofSize: 23)
        } else {
            label.font = UIFont.systemFont(ofSize: 14)
        }
        label.text = title
    }
}
