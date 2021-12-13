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
    var lastIndexUsed: Int!
    var ingredientList: String!
    private let service: RequestService = RequestService()
    var isLoading = false
    
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
    
    func fetchRecipesFromEdamam(from: Int, to: Int) {
        service.getData(ingredients: ingredientList, fromIndex: from, toIndex: to) { result in
//            self.service.getData(ingredients: "lemon", fromIndex: 6, toIndex: 10) { result in
            switch result {
            case .success(let recipesApi) :
//                print(recipesApi)
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
                    print(recipe)
                    self.data.append(recipe)
                }
                self.recipeTableView.reloadData()
                self.isLoading = false

            case .failure(_):
                break
            }
        }
        
        
        self.tableView.reloadData()
        self.isLoading = false
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let start = data.count
            let end = start + 5
//            sleep(2)
            fetchRecipesFromEdamam(from: start, to: end)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }


//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return data.count
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = data[indexPath.row]
        cell.recipe = recipe
        cell.setupCell()
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250 //Item Cell height
        } else {
            return 400 //Loading Cell height
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = data[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: recipe)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 1) && !isLoading {
            loadMoreData()
        }
    }
    

}
