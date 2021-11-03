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
    
    var recipe: Recipe! {
        didSet {
            nameLabel.text = "\(recipe.label)"
            recipeImage.load(urlString: recipe.image)
            ingredientsListLabel.text = renderIngredientsListInOneString(recipe: recipe)
        }
    }
    
    func setupCell(_ recipe: Recipe) {
        recipeImage.layer.cornerRadius = 20
    }
    
    func renderIngredientsListInOneString(recipe: Recipe) -> String{
        var theString = ""
        
        for ingredient in recipe.ingredients {
            theString = "\(theString)\(ingredient.food) "
        }
        
        return theString
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
