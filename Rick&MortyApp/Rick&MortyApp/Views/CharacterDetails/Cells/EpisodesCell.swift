//
//  EpisodesCell.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

class EpisodesCell: UITableViewCell {
    
    private lazy var backroundV: UIView = {
        let backroundV = UIView()
        backroundV.backgroundColor = Colors().cards
        backroundV.layer.cornerRadius = 16
        backroundV.translatesAutoresizingMaskIntoConstraints = false
        return backroundV
    }()
    
    private lazy var episodeNameLabel: UILabel = {
        let episodeNameLabel = UILabel()
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeNameLabel.font = UIFont(name: Fonts().gilroySemiBold, size: 17)
        episodeNameLabel.textColor = .white
        return episodeNameLabel
    }()
    
    private lazy var episodeNumberLabel: UILabel = {
        let episodeNumberLabel = UILabel()
        episodeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeNumberLabel.font = UIFont(name: Fonts().gilroyMedium, size: 13)
        episodeNumberLabel.textColor = Colors().green
        return episodeNumberLabel
    }()
    
    private lazy var episodeDateLabel: UILabel = {
        let episodeDateLabel = UILabel()
        episodeDateLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeDateLabel.font = UIFont(name: Fonts().gilroyMedium, size: 12)
        episodeDateLabel.textColor = Colors().grayDateText
        episodeDateLabel.textAlignment = .right
        return episodeDateLabel
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
        backroundV.addSubview(episodeNameLabel)
        backroundV.addSubview(episodeNumberLabel)
        backroundV.addSubview(episodeDateLabel)
        
        NSLayoutConstraint.activate ([
            backroundV.topAnchor.constraint(equalTo: self.topAnchor),
            backroundV.leftAnchor.constraint(equalTo: self.leftAnchor),
            backroundV.rightAnchor.constraint(equalTo: self.rightAnchor),
            backroundV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14),
            
            episodeNameLabel.topAnchor.constraint(equalTo: backroundV.topAnchor, constant: 16),
            episodeNameLabel.leftAnchor.constraint(equalTo: backroundV.leftAnchor, constant: 16),
            episodeNameLabel.rightAnchor.constraint(equalTo: backroundV.rightAnchor, constant: -16),
            
            episodeNumberLabel.bottomAnchor.constraint(equalTo: backroundV.bottomAnchor, constant: -14),
            episodeNumberLabel.leftAnchor.constraint(equalTo: backroundV.leftAnchor, constant: 16),
            
            episodeDateLabel.bottomAnchor.constraint(equalTo: backroundV.bottomAnchor, constant: -16),
            episodeDateLabel.rightAnchor.constraint(equalTo: backroundV.rightAnchor, constant: -16),
        ])
    }
    
    func setup(episode: Episode) {
        episodeNameLabel.text = episode.name
        episodeDateLabel.text = episode.air_date
        episodeNumberLabel.text = convertToEpisodeString(input: episode.episode)
    }
    
    func convertToEpisodeString(input: String) -> String {
        let components = input.components(separatedBy: "E")
        
        guard let season = components.first?.replacingOccurrences(of: "S", with: ""),
              let episode = components.last else {
            return input
        }
        
        let episodeString = "Episode: \(episode), Season: \(season)"
        return episodeString
    }
}
