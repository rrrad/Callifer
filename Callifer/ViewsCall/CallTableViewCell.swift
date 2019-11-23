//
//  CallTableViewCell.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 08.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class CallTableViewCell: UITableViewCell {
    private lazy var imageCall: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage.init(named: "incoming_arrow")
        return image
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        label.backgroundColor = UIColor.green
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    var callState: CallState? {
        didSet {
            guard let callState = callState else {return}
            switch callState {
            case .active:
                stateLabel.text = "Active"
            case .connecting:
                stateLabel.text = "Connecting..."
            case .ended:
                stateLabel.text = "Active"
            default:
                stateLabel.text = "Dialing..."
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageCall)
        contentView.addSubview(numberLabel)
        contentView.addSubview(stateLabel)

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
        imageCall.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: imageCall.trailingAnchor, constant: 2.0).isActive = true
        stateLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 2.0).isActive = true
        stateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0).isActive = true
        
        imageCall.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        numberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        stateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        
        imageCall.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        stateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true

        imageCall.widthAnchor.constraint(equalToConstant: contentView.frame.height).isActive = true
        stateLabel.widthAnchor.constraint(equalToConstant: 50.0).isActive = true

    }

    func setNumber(number: String){
        numberLabel.text = number
    }
    
    func setState(state: CallState) {
        callState = state
    }
}
