//
//  FavoriteController.swift
//  Reciplease
//
//  Created by Pierre on 04/11/2021.
//

import UIKit




class FavoriteRecipeViewController: UITableViewController {
    //MARK: Outlet
    @IBOutlet private var favoriteRecipeTableView: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDataFromCoreData()
    }
    
    //MARK: Variable
    private var coreDataManager: CoreDataManager?
    private var favoriteRecipeManager = FavoriteRecipeManager()
    private var recipeList: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate else { return }
        let coreDataStack = sceneDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        let nibName = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        favoriteRecipeTableView.register(nibName, forCellReuseIdentifier: "recipeCell")
    }
    
   
    
    //MARK: Function
    private func fetchDataFromCoreData() {
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        recipeList = favoriteRecipeManager.convertFavoriteListToRecipeList(favoriteList: list)
        favoriteRecipeTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailFromFavorite" else { return }
        var recipeSelected = sender as? Recipe
        recipeSelected?.recipceFromFavorite = true
        guard let controller = segue.destination as? RecipeDetailViewController else { return }
        controller.recipeSelected = recipeSelected
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteRecipeTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        cell.recipe = recipeList[indexPath.row]
        cell.setupCell()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let coreDataManager = coreDataManager else {
                return
            }

            coreDataManager.deleteFavoriteRecipe(urlRecipe: recipeList[indexPath.row].urlToWebPageRecipe)
            fetchDataFromCoreData()
            favoriteRecipeTableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailFromFavorite", sender: recipeList[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add recipes from Search!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return recipeList.isEmpty ? 500 : 0
    }
}
