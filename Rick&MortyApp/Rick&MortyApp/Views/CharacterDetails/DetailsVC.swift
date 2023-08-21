//
//  DetailsVC.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    let networkService: NetworkService
    let character: Character
    
    init(character: Character, networkService: NetworkService) {
        self.character = character
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var episodesMassive = [Episode?]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.alpha = 0
        titleLabel.font = UIFont(name: Fonts().gilroyBold, size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HeaderCell.self, forCellReuseIdentifier: "Header")
        tableView.register(HeaderForCells.self, forHeaderFooterViewReuseIdentifier: "HeaderCells")
        tableView.register(InfoCell.self, forCellReuseIdentifier: "Info")
        tableView.register(OriginCell.self, forCellReuseIdentifier: "Origin")
        tableView.register(EpisodesCell.self, forCellReuseIdentifier: "Episodes")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Colors().background
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.alpha = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().background
        setupView()
        getEpisodes()
    }
    
    private func setupView() {
        
        view.addSubview(activityIndicator)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(tableView)
        
        titleLabel.text = character.name
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: guide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 34),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getEpisodes() {
        activityIndicator.startAnimating()
        
        var episodes = [Episode?]()
        
        let dispatchGroup = DispatchGroup()
        
        character.episode.forEach { url in
            dispatchGroup.enter()
            
            networkService.getEpisodes(for: url) { episode, textError in
                DispatchQueue.main.async {
                    episodes.append(episode)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            
            let sortedDates = episodes.sorted { stringDate1, stringDate2 in
                guard let strDate1 = stringDate1?.air_date,
                      let strDate2 = stringDate2?.air_date else {
                    return false
                }
                
                guard let date1 = dateFormatter.date(from: strDate1),
                      let date2 = dateFormatter.date(from: strDate2) else {
                    return false
                }
                return date1 < date2
            }
            self.episodesMassive = sortedDates.compactMap { $0 }
            self.tableView.reloadData()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.activityIndicator.stopAnimating()
                self.tableView.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func backButtonAction() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0) }) { _ in
                self.dismiss(animated: false, completion: nil)
            }
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        } else {
            return episodesMassive.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderCell
            cell.setup(character: character)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Info", for: indexPath) as! InfoCell
            cell.setup(character: character)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Origin", for: indexPath) as! OriginCell
            cell.setup(character: character)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Episodes", for: indexPath) as! EpisodesCell
            let ep = episodesMassive[indexPath.row]
            if let unwrappedEp = ep {
                cell.setup(episode: unwrappedEp)
            } else {
                print("Error of episodes")
                return cell
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        } else if indexPath.section == 1 {
            return 125
        } else if indexPath.section == 2 {
            return 94
        } else if indexPath.section == 3 {
            return 100
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCells") as! HeaderForCells
            if section == 1 {
                header.setupHeaderTitle(title: Texts().infoCellTitle)
            } else if section == 2 {
                header.setupHeaderTitle(title: Texts().originCellTitle)
            } else if section == 3 {
                header.setupHeaderTitle(title: Texts().episodesCellTitle)
            }
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 35
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.alpha = 0
                }, completion:  nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.alpha = 1
                }, completion:  nil)
            }
        }
    }
}
