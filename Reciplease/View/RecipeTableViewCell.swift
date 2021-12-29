//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Pierre on 03/12/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    //MARK: Outlet
    @IBOutlet weak private var generalView: UIView!
    @IBOutlet weak private var backgroundImageView: UIImageView!
    
    @IBOutlet weak private var bottomView: UIView!
    @IBOutlet weak private var recipeNameLabel: UILabel!
    @IBOutlet weak private var ingredientsLabel: UILabel!
    
    @IBOutlet weak private var topRightView: UIView!
    @IBOutlet weak private var delayLabel: UILabel!
    @IBOutlet weak private var caloriesLabel: UILabel!
    
    //MARK: - Public
    //MARK: Variables
    var recipe: Recipe! {
        didSet {
            backgroundImageView.load(urlString: recipe.image)
            recipeNameLabel.text = recipe.name
            ingredientsLabel.text = ingredientListFormatterService.renderIngredientsListInOneString(recipe: recipe)
            delayLabel.text = timeFormatterService.returnTime(minutes: Int(recipe.totalTime))
            caloriesLabel.text = "\(Int(recipe.calories)) calories"
        }
    }
    private let timeFormatterService = TimeFormatterService()
    private let ingredientListFormatterService = IngredientListFormatterService()
    
    //MARK: Functions
    func setupCell() {
        backgroundImageView.layer.cornerRadius = 20
        topRightView.layer.cornerRadius = 20
        topRightView.layer.borderWidth = 2
        topRightView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    //MARK: - Private
    //MARK: Functions
    private func commonInit(imageName: String, name: String, ingredients: String, delay: String) {
        backgroundImageView.image = UIImage(named: imageName)
        recipeNameLabel.text = name
        ingredientsLabel.text = ingredients
        delayLabel.text = delay
    }
}

