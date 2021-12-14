//
//  ViewController.swift
//  Reciplease
//
//  Created by Pierre on 29/10/2021.
//

import UIKit
import Alamofire

class SearchController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    //MARK: variables
//    var search = Search()
    let api = ApiConstant()
    var searchText = ""
    var urlToNextPage = ""
    var readyToShow = false
    private let baseUrl: String = ""
    
    
    var ingredientsInRequest: String = ""
    var recipeList: [Recipe] = []
    var ingredientList: [String] = []
    var loading: Bool = false
    
    private let service: RequestService = RequestService()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        updateView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        showListIngredients()
    }
    
    //MARK: functions
    func updateView() {
        ingredientsTableView.backgroundView?.backgroundColor = UIColor(named: "white")
    }
    
    func fetchRecipesFromEdamam() {
//        service.getData(ingredients: self.ingredientsInRequest, fromIndex: 0, toIndex: 6) { result in
        service.getData(ingredients: "chicken") { result in
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
                    self.recipeList.append(recipe)
                }

                self.loading(load: false)
                self.performSegue(withIdentifier: "resultOfRecipesSearch", sender: self.recipeList)
            case .failure(_):
                break
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No recipe found !", message: "Please, check the list of ingredients.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }
    ))

        self.present(alert, animated: true)
    }
    
    func showListIngredients() {
        ingredientsTableView.reloadData()
    }
    
    func updateIngredientsInRequest() {
        var text = ""
        for ingredient in ingredientList {
            text = "\(text)\(ingredient),"
        }
        ingredientsInRequest = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultOfRecipesSearch" {
            if let newController = segue.destination as? ResultSearchController {
                if let data = sender as? [Recipe] {
                    newController.data = data
                    newController.urlToNextPage = urlToNextPage
                }
            }
        }
    }
    
    func loading(load: Bool) {
        if load {
            searchButton.layer.isHidden = true
            activityIndicator.layer.isHidden = false
        } else {
            searchButton.layer.isHidden = false
            activityIndicator.layer.isHidden = true
        }
        
    }
    
    //MARK: actions
    @IBAction func addIngredient(_ sender: Any) {
//        search.addIngredientInList(ingredientName: searchText)
        ingredientList.append(searchText)
        searchText = ""
        searchTextField.text = ""
        showListIngredients()
    }
    @IBAction func updateSearch(_ sender: UITextField) {
        let text = sender.text ?? ""
        searchText = text
    }
    
    @IBAction func resetList(_ sender: Any) {
//        search.resetIngredientInList()
        ingredientList.removeAll()
        showListIngredients()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        loading(load: true)
        updateIngredientsInRequest()
        fetchRecipesFromEdamam()
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "\(ingredientList[indexPath.row])"

        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
