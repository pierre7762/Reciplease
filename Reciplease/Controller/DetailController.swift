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
    private var isItFavorite: Bool = false

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
        isItFavorite = checkFavorite
        updateFavoriteButton()
    }
    
    //MARK: Function
    private func updateView() {
        recipeImageView.load(urlString: recipeSelected.image)
        recipeNameLabel.text = recipeSelected.name
        updateFavoriteButton()
    }
    
    private func renderIngredientsLines() -> String{
        var text = ""
        for item in recipeSelected.ingredientsLines {
            text = "\(text)\n - \(item)"
        }
        return text
    }
    
    private func updateFavoriteButton() {
        if recipeFrom == "FavoriteController" {
            favoriteBarButton.image = UIImage(named: "heartSelected.png")
        } else {
            
            if isItFavorite {
                favoriteBarButton.image = UIImage(named: "heartSelected.png")
            } else {
                favoriteBarButton.image = UIImage(named: "heart.png")
            }
        }
    }
    
    //MARK: Action
    
    @IBAction func goToRecipeWebPage(_ sender: UIButton) {
        if let url = URL(string: recipeSelected.urlToWebPageRecipe) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if recipeFrom == "FavoriteController" {
            coreDataManager?.deleteFavoriteRecipe(urlRecipe: recipeSelected.urlToWebPageRecipe)
            print("delete")
            navigationController?.popViewController(animated: true)
            
        } else if recipeFrom == "ResultSearchController" {
            if  favoriteBarButton.image == UIImage(named: "heartSelected.png") {
                print("selecte")
                coreDataManager?.deleteFavoriteRecipe(urlRecipe: recipeSelected.urlToWebPageRecipe)
                print("delete")
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
