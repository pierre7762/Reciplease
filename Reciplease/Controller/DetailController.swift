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
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    //MARK: Variable
    var recipeSelected: Recipe!
    var recipeFrom: String!
    private var coreDataManager: CoreDataManager?
    private var favoritList: [Recipe]! = []

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
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        favoritList = list.map {
            let ingredients = $0.ingredientsList?.allObjects as! [FavoriteIngredient]
            return Recipe(
                name: $0.name!,
                image: $0.image!,
                ingredientsLines: $0.ingredientsLines!,
                ingredients: ingredients.map {  Ingredient(text: $0.text!, quantity: $0.quantity, measure: $0.measure, food: $0.food!, weight: $0.weight, image: $0.image!)},
                totalTime: $0.totalTime,
                urlToWebPageRecipe: $0.urlToWebPageRecipe!,
                calories: $0.calories
            )
        }
        updateFavoriteButton()
    }
    
    //MARK: Function
    func updateView() {
        recipeImageView.load(urlString: recipeSelected.image)
        recipeNameLabel.text = recipeSelected.name
        updateFavoriteButton()
    }
    
    func renderIngredientsLines() -> String{
        var text = ""
        for item in recipeSelected.ingredientsLines {
            text = "\(text)\n - \(item)"
        }
        return text
    }
    
    func updateFavoriteButton() {
        if recipeFrom == "FavoriteController" {
            favoriteBarButton.image = UIImage(named: "heartSelected.png")
        } else {
            var isSelected = false
            for favorite in favoritList {
                if recipeSelected.name == favorite.name {
                    isSelected = true
                }
            }
            
            if isSelected {
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
        if recipeFrom == "FavoriteController" {
            guard let list = coreDataManager?.favoriteRecipesList else { return }
            for fav in list {
                if fav.name == recipeSelected.name {
                    self.coreDataManager?.deleteFavoriteRecipe(index: list.firstIndex(of: fav)!)
                    print("delete")
                    navigationController?.popViewController(animated: true)
                }
            }
            
        } else if recipeFrom == "ResultSearchController" {
            if  favoriteBarButton.image == UIImage(named: "heartSelected.png") {
                print("selecte")
                guard let list = coreDataManager?.favoriteRecipesList else { return }
                for fav in list {
                    if fav.name == recipeSelected.name {
                        self.coreDataManager?.deleteFavoriteRecipe(index: list.firstIndex(of: fav)!)
                        print("delete")
                    }
                }
                favoriteBarButton.image = UIImage(named: "heart.png")
            } else {
                print("not selected")
                self.coreDataManager?.addFavoriteRecipe(recipe: recipeSelected)
                self.favoriteBarButton.image = UIImage(named: "heartSelected.png")
            }
        }
    }
}

extension DetailController: UITableViewDelegate, UITableViewDataSource {
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
