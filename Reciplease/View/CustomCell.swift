//
//  CustomCell.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var recipe: Recipe! {
        didSet {
            nameLabel.text = "\(recipe.name)"
            recipeImage.load(urlString: recipe.image)
            ingredientsListLabel.text = renderIngredientsListInOneString(recipe: recipe)
            timeLabel.text = returnTime(seconds: Int(recipe.totalTime))
        }
    }
    
    func setupCell(_ recipe: Recipe) {
        recipeImage.layer.cornerRadius = 20
        infoView.layer.cornerRadius = 20
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    func renderIngredientsListInOneString(recipe: Recipe) -> String{
        var theString = ""
        
        for ingredient in recipe.ingredients {
            theString = "\(theString)\(ingredient.food) "
        }
        
        return theString
    }
    
    func secondsToHoursMinutes (seconds : Int) -> (Int, Int) {
       (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func returnTime(seconds: Int) -> String {
        let (h, m) = secondsToHoursMinutes(seconds: seconds)
        
        if h == 0 && m > 0 {
            return "\(m)m"
        } else if m == 0 && h > 0 {
            return "\(h)h"
        } else if h == 0 && m == 0 {
            return "?"
        } else {
            return "\(h)h\(m)"
        }
    }

}

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
            }
        }
    }
}
