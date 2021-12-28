//
//  DetailController.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit
import SafariServices

class RecipeDetailViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak private var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak private var recipeImageView: UIImageView!
    @IBOutlet weak private var recipeNameLabel: UILabel!
    @IBOutlet weak private var ingredientsTableView: UITableView!
    
    //MARK: Variable
    var recipeSelected: Recipe!
    private var coreDataManager: CoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        //MARK: To fetch the scene delegate
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate else { return }
        let coreDataStack = sceneDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let checkFavorite = coreDataManager?.isItFavoriteRecipe(urlRecipe: recipeSelected.urlToWebPageRecipe) else { return }
        recipeSelected.favorite = checkFavorite
        updateFavoriteButton()
    }
    
    //MARK: Function
    private func updateView() {
        recipeImageView.load(urlString: recipeSelected.image)
        recipeNameLabel.text = recipeSelected.name
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        if recipeSelected.recipceFromFavorite {
            favoriteBarButton.image = UIImage(named: "heartSelected.png")
        } else {
            if recipeSelected.favorite {
                favoriteBarButton.image = UIImage(named: "heartSelected.png")
            } else {
                favoriteBarButton.image = UIImage(named: "heart.png")
            }
        }
    }
    
    //MARK: Action
    
    @IBAction func goToRecipeWebPage(_ sender: UIButton) {
        if let url = URL(string: recipeSelected.urlToWebPageRecipe) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if recipeSelected.recipceFromFavorite {
            coreDataManager?.deleteFavoriteRecipe(urlRecipe: recipeSelected.urlToWebPageRecipe)
            navigationController?.popViewController(animated: true)
            
        } else {
            if recipeSelected.favorite {
                coreDataManager?.deleteFavoriteRecipe(urlRecipe: recipeSelected.urlToWebPageRecipe)
                favoriteBarButton.image = UIImage(named: "heart.png")
                recipeSelected.favorite = false
            } else {
                self.coreDataManager?.addFavoriteRecipe(recipe: recipeSelected)
                self.favoriteBarButton.image = UIImage(named: "heartSelected.png")
                recipeSelected.favorite = true
            }
        }
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeSelected.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "\(recipeSelected.ingredients[indexPath.row].text)"

        cell.contentConfiguration = content
        
        return cell
    }
}
