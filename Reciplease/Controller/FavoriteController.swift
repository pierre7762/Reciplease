//
//  FavoriteController.swift
//  Reciplease
//
//  Created by Pierre on 04/11/2021.
//

import UIKit

class FavoriteController: UITableViewController {
    //MARK: Outlet
    @IBOutlet var favoriteRecipeTableView: UITableView!
    
    //MARK: Variable
    private var coreDataManager: CoreDataManager?
    private var favoritList: [FavoriteRecipe]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate else { return }
        let coreDataStack = sceneDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        let nibName = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        favoriteRecipeTableView.register(nibName, forCellReuseIdentifier: "recipeCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        favoritList = list
        favoriteRecipeTableView.reloadData()
    }
    
    //MARK: Function
    private func fetchDataFromCorData() {
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        favoritList = list
        favoriteRecipeTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailFromFavorite" else { return }
        guard let controller = segue.destination as? DetailController else { return }
        controller.recipeSelected = sender as? Recipe
        controller.recipeFrom = "FavoriteController"
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteRecipeTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        let favoriteToShow = favoritList[indexPath.row]
        let ingredients = favoriteToShow.ingredientsList?.allObjects as! [FavoriteIngredient]
        let favoriteToRecipeType = Recipe(
            name: favoriteToShow.name! as String,
            image: favoriteToShow.image! as String,
            ingredientsLines: favoriteToShow.ingredientsLines!,
            ingredients: ingredients.map {  Ingredient(text: $0.text!, quantity: $0.quantity, measure: $0.measure, food: $0.food!, weight: $0.weight, image: $0.image!)},
            totalTime: favoriteToShow.totalTime,
            urlToWebPageRecipe: favoriteToShow.urlToWebPageRecipe! as String,
            calories: favoriteToShow.calories
        )
        cell.recipe = favoriteToRecipeType
        cell.setupCell()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataManager!.deleteFavoriteRecipe(index: indexPath.row)
            fetchDataFromCorData()
            favoriteRecipeTableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteToShow = favoritList[indexPath.row]
        let ingredients = favoriteToShow.ingredientsList?.allObjects as! [FavoriteIngredient]
        let favoriteToRecipeType = Recipe(
            name: favoriteToShow.name! as String,
            image: favoriteToShow.image! as String,
            ingredientsLines: favoriteToShow.ingredientsLines!,
            ingredients: ingredients.map {  Ingredient(text: $0.text!, quantity: $0.quantity, measure: $0.measure, food: $0.food!, weight: $0.weight, image: $0.image!)},
            totalTime: favoriteToShow.totalTime,
            urlToWebPageRecipe: favoriteToShow.urlToWebPageRecipe! as String,
            calories: favoriteToShow.calories
        )
        performSegue(withIdentifier: "toDetailFromFavorite", sender: favoriteToRecipeType)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Find your favorite recipes here!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return favoritList.isEmpty ? 500 : 0
    }
}
