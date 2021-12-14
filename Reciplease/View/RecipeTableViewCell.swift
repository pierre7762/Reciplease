//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Pierre on 03/12/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    //MARK: Outlet
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    //MARK: Variables
    var recipe: Recipe! {
        didSet {
            backgroundImageView.load(urlString: recipe.image)
            recipeNameLabel.text = recipe.name
            ingredientsLabel.text = renderIngredientsListInOneString(recipe: recipe)
            delayLabel.text = returnTime(minutes: Int(recipe.totalTime))
            caloriesLabel.text = "\(Int(recipe.calories)) calories"
        }
    }
    
    //MARK: Functions
    func commonInit(imageName: String, name: String, ingredients: String, delay: String) {
        backgroundImageView.image = UIImage(named: imageName)
        recipeNameLabel.text = name
        ingredientsLabel.text = ingredients
        delayLabel.text = delay
    }
    
    func renderIngredientsListInOneString(recipe: Recipe) -> String{
        var theString = ""
        
        for ingredient in recipe.ingredients {
            theString = "\(theString)\(ingredient.food) "
        }
        
        return theString
    }
    
    func minutesToHoursMinutes (seconds : Int) -> (Int, Int) {
       (seconds / 60, (seconds % 60))
    }
    
    func returnTime(minutes: Int) -> String {
        let (h, m) = minutesToHoursMinutes(seconds: minutes)
        
        if h == 0 && m > 0 {
            return "⏱ \(m)min"
        } else if m == 0 && h > 0 {
            return "⏱ \(h)h"
        } else if h == 0 && m == 0 {
            return "⏱ unknown"
        } else {
            return "⏱ \(h)h\(m)"
        }
    }
    
    func setupCell() {
        backgroundImageView.layer.cornerRadius = 20
        topRightView.layer.cornerRadius = 20
        topRightView.layer.borderWidth = 2
        topRightView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
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
