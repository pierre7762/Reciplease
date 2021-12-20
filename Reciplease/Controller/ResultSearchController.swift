//
//  ResultSearchController.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit

class ResultSearchController: UITableViewController {
    @IBOutlet var recipeTableView: UITableView!
    
    var data: [Recipe]!
    var urlToNextPage: String!
    private let service: RequestService = RequestService()
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipeTableView.register(nibName, forCellReuseIdentifier: "recipeCell")
        
        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        recipeTableView.register(loadingCellNib, forCellReuseIdentifier: "loadingcellid")
    }

    //MARK: functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetail" else { return }
        guard let controller = segue.destination as? DetailController else { return }
        controller.recipeSelected = sender as? Recipe
        controller.recipeFrom = "ResultSearchController"
    }
    
    private func fetchRecipesFromEdamam() {
        service.getNextPage(urlNextPage: urlToNextPage) { result in
            switch result {
            case .success(let recipesApi) :
                self.urlToNextPage = recipesApi.links.next.href
                for item in recipesApi.hits {
                    let recipe = Recipe(
                        name: item.recipe.label,
                        image: item.recipe.image,
                        ingredientsLines: item.recipe.ingredientLines,
                        ingredients: item.recipe.ingredients,
                        totalTime: Double(item.recipe.totalTime),
                        urlToWebPageRecipe: item.recipe.url,
                        calories: item.recipe.calories
                    )
                    self.data.append(recipe)
                }
                self.recipeTableView.reloadData()

            case .failure(_):
                let alert = UIAlertController(title: "Error", message: "The data can not be loaded.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = data[indexPath.row]
        cell.recipe = recipe
        cell.setupCell()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = data[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: recipe)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            fetchRecipesFromEdamam()
        }
    }
}
