//
//  DetailController.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit
import SafariServices

class DetailController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsQuantityTextField: UITextView!
    
    //MARK: Variable
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.load(urlString: recipe.image)
        recipeNameLabel.text = recipe.name
        recipeIngredientsQuantityTextField.text = renderIngredientsLines()
//        updateFavoriteButton()
    }
    
    //MARK: Function
    func renderIngredientsLines() -> String{
        var text = ""
        for item in recipe.ingredientsLines {
            text = "\(text)\n - \(item)"
        }
        return text
    }
    
    func updateFavoriteButton() {
        if recipe.favorite {
            favoriteBarButton.image = UIImage(named: "star")
        } else {
            favoriteBarButton.image = UIImage(named: "star.fill")
        }
    }
    
//    func saveRecipe(recipe: Recipe) {
//        let favoriteRepice = FavoriteRecipe(context: AppDelegate.viewContext)
//        favoriteRepice.name = recipe.name
//        favoriteRepice.image = recipe.image
//        favoriteRepice.ingredientsLines = recipe.ingredientsLines
//        favoriteRepice.ingredients = recipe.ingredients
//        favoriteRepice.totalTime = recipe.totalTime
//        favoriteRepice.urlToWebPageRecipe = recipe.urlToWebPageRecipe
//        favoriteRepice.favorite = true
//    }
    
    //MARK: Action
    
    @IBAction func goToRecipeWebPage(_ sender: UIButton) {
        if let url = URL(string: recipe.urlToWebPageRecipe) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if recipe.favorite {
            recipe.favorite = false
            updateFavoriteButton()
        } else {
            recipe.favorite = true
            updateFavoriteButton()
        }
    }
    

}
