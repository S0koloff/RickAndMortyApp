//
//  CharactersCollectionViewCell.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 19.08.2023.
//

import UIKit

protocol CharactersCollectionCellProtocol {
    func openCharacter(id: Int)
}

class CharactersCollectionViewCell: UICollectionViewCell {
    
    var delegate: CharactersCollectionCellProtocol?
    
    var id = 0
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.backgroundColor = .gray
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var avatarNameLabel: UILabel = {
        let avatarNameLabel = UILabel()
        avatarNameLabel.font = UIFont(name: Fonts().gilroySemiBold, size: 17)
        avatarNameLabel.textAlignment = .center
        avatarNameLabel.textColor = .white
        avatarNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return avatarNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(avatarNameLabel)
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            avatarImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            avatarImage.bottomAnchor.constraint(equalTo: avatarNameLabel.topAnchor, constant: -16),
            
            avatarNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarNameLabel.heightAnchor.constraint(equalToConstant: 22),
            avatarNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            avatarNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            avatarNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    override func layoutSubviews() {
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 10
    }
    
    func setup(characters: Character) {
        avatarImage.loadImage(from: characters.image)
        avatarNameLabel.text = characters.name
        id = characters.id
    }
    
    private func setupGesture() {
        let characterTap = UITapGestureRecognizer(target: self, action: #selector(characterTapAction))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(characterTap)
    }
    
    @objc private func characterTapAction(_ sender: UITapGestureRecognizer) {
        self.delegate?.openCharacter(id: id)
    }
}
