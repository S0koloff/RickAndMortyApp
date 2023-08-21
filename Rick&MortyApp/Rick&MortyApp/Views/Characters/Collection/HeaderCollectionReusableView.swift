//
//  HeaderCollectionReusableView.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 19.08.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Texts().charactersTitle
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: Fonts().gilroyBold, size: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public func config() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
        ])
    }
}
