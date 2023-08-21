//
//  Extensions.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                print("Failed to load image: \(urlString)")
            }
        }
    }
}
