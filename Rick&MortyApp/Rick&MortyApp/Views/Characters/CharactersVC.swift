//
//  CharactersViewController.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 19.08.2023.
//

import UIKit

final class CharactersViewController: UIViewController {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var characters = [Character]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    private lazy var charactersCollection: UICollectionView = {
        let charactersCollection = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        charactersCollection.delegate = self
        charactersCollection.dataSource = self
        charactersCollection.register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        charactersCollection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        charactersCollection.showsVerticalScrollIndicator = false
        charactersCollection.translatesAutoresizingMaskIntoConstraints = false
        charactersCollection.backgroundColor = Colors().background
        charactersCollection.alpha = 0
        return charactersCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().background
        setupView()
        getCharacters()
    }
    
    private func getCharacters() {
        activityIndicator.startAnimating()
        var charCount = 0
        
        for number in 1...42 {
            networkService.getCharacters(for: number) { characters, errorText in
                DispatchQueue.main.async {
                    characters?.forEach { character in
                        self.characters.insert(character, at: 0)
                    }
                    
                    charCount += 1
                    
                    if charCount == 42 {
                        self.characters.sort { $0.id < $1.id }
                        self.charactersCollection.reloadData()
                        UIView.animate(withDuration: 1, animations: {
                            self.activityIndicator.stopAnimating()
                            self.charactersCollection.alpha = 1
                        }, completion:  nil)
                    }
                }
            }
        }
    }
    
    private func setupView() {
        view.addSubview(activityIndicator)
        view.addSubview(charactersCollection)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            charactersCollection.topAnchor.constraint(equalTo: guide.topAnchor),
            charactersCollection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            charactersCollection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            charactersCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharactersViewController: CharactersCollectionCellProtocol {
    
    func openCharacter(id: Int) {
        guard let character = self.characters.first(where: {$0.id == id}) else {
            print("Error of id")
            return
        }
        
        let vc = DetailsViewController(character: character, networkService: networkService)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharactersCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = Colors().cards
        let char = characters[indexPath.row]
        cell.setup(characters: char)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 202)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderCollectionReusableView
        header.config()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 156, height: 30)
    }
}
