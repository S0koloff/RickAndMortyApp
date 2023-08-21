//
//  OriginCell.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

class OriginCell: UITableViewCell {
    
    private lazy var backroundV: UIView = {
        let backroundV = UIView()
        backroundV.backgroundColor = Colors().cards
        backroundV.layer.cornerRadius = 16
        backroundV.translatesAutoresizingMaskIntoConstraints = false
        return backroundV
    }()
    
    private lazy var planetBackground: UIView = {
        let planetBackground = UIView()
        planetBackground.backgroundColor = Colors().planetBackground
        planetBackground.layer.cornerRadius = 10
        planetBackground.translatesAutoresizingMaskIntoConstraints = false
        return planetBackground
    }()
    
    private lazy var planetImage: UIImageView = {
        let planetImage = UIImageView()
        planetImage.image = UIImage(named: "Planet")
        planetImage.contentMode = .scaleAspectFill
        planetImage.translatesAutoresizingMaskIntoConstraints = false
        return planetImage
    }()
    
    private lazy var planetNameLabel: UILabel = {
        let planetNameLabel = UILabel()
        planetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        planetNameLabel.font = UIFont(name: Fonts().gilroySemiBold, size: 17)
        planetNameLabel.textColor = .white
        return planetNameLabel
    }()
    
    private lazy var planetLabel: UILabel = {
        let planetLabel = UILabel()
        planetLabel.translatesAutoresizingMaskIntoConstraints = false
        planetLabel.font = UIFont(name: Fonts().gilroyMedium, size: 13)
        planetLabel.textColor = Colors().green
        planetLabel.text = Texts().originPlanet
        return planetLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.backgroundColor = Colors().background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(backroundV)
        backroundV.addSubview(planetBackground)
        planetBackground.addSubview(planetImage)
        backroundV.addSubview(planetNameLabel)
        backroundV.addSubview(planetLabel)
        
        NSLayoutConstraint.activate ([
            backroundV.topAnchor.constraint(equalTo: self.topAnchor),
            backroundV.leftAnchor.constraint(equalTo: self.leftAnchor),
            backroundV.rightAnchor.constraint(equalTo: self.rightAnchor),
            backroundV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14),
            
            planetBackground.centerYAnchor.constraint(equalTo: backroundV.centerYAnchor),
            planetBackground.leftAnchor.constraint(equalTo: backroundV.leftAnchor, constant: 8),
            planetBackground.widthAnchor.constraint(equalToConstant: 64),
            planetBackground.heightAnchor.constraint(equalToConstant: 64),
            
            planetImage.centerYAnchor.constraint(equalTo: planetBackground.centerYAnchor),
            planetImage.centerXAnchor.constraint(equalTo: planetBackground.centerXAnchor),
            planetImage.widthAnchor.constraint(equalToConstant: 24),
            planetImage.heightAnchor.constraint(equalToConstant: 24),
            
            planetNameLabel.topAnchor.constraint(equalTo: backroundV.topAnchor, constant: 16),
            planetNameLabel.leftAnchor.constraint(equalTo: planetBackground.rightAnchor, constant: 16),
            planetNameLabel.rightAnchor.constraint(equalTo: backroundV.rightAnchor, constant: -16),
            
            planetLabel.bottomAnchor.constraint(equalTo: backroundV.bottomAnchor, constant: -16),
            planetLabel.leftAnchor.constraint(equalTo: planetBackground.rightAnchor, constant: 16),
        ])
    }
    
    func setup(character: Character) {
        planetNameLabel.text = character.origin.name
    }
}
