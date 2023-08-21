//
//  HeaderCell.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.backgroundColor = .gray
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: Fonts().gilroyBold, size: 22)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont(name: Fonts().gilroyMedium, size: 16)
        statusLabel.textAlignment = .center
        statusLabel.textColor = Colors().green
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors().background
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(avatarImage)
        self.addSubview(nameLabel)
        self.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: self.topAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: 148),
            avatarImage.heightAnchor.constraint(equalToConstant: 148),
            avatarImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    func setup(character: Character) {
        avatarImage.loadImage(from: character.image)
        nameLabel.text = character.name
        statusLabel.text = character.status
    }
    
    override func layoutSubviews() {
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 10
        
        if statusLabel.text == "Alive" {
            statusLabel.textColor = Colors().green
        } else if statusLabel.text == "Dead" {
            statusLabel.textColor = .red
        } else {
            statusLabel.textColor = Colors().lightGrayText
        }
    }
    
}
