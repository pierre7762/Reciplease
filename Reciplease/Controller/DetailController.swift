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
    var recipeSelected: Recipe!
    private var coreDataManager: CoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeImageView.load(urlString: recipeSelected.image)
        recipeNameLabel.text = recipeSelected.name
        recipeIngredientsQuantityTextField.text = renderIngredientsLines()
//        updateFavoriteButton()
        //MARK: To fetch the scene delegate
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate else { return }
        let coreDataStack = sceneDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    //MARK: Function
    func renderIngredientsLines() -> String{
        var text = ""
        for item in recipeSelected.ingredientsLines {
            text = "\(text)\n - \(item)"
        }
        return text
    }
    
    func updateFavoriteButton() {
        if recipeSelected.favorite {
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
        if let url = URL(string: recipeSelected.urlToWebPageRecipe) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        self.coreDataManager?.addFavoriteRecipe(recipe: recipeSelected)
        updateFavoriteButton()
    }
    

}
