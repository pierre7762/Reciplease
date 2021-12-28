//
//  Extensions.swift
//  Reciplease
//
//  Created by Pierre on 28/12/2021.
//

import UIKit


extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            } else {
                let image = UIImage(named: "logo")
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
